module Migration
  class MigrationFailurePresenter < SimpleDelegator
    def self.wrap(collection)
      collection.map { |record| new(record) }
    end

    def failure_type
      @failure_type ||= friendly_error_type(parse_failure_message.first)
    end

    def participant_profile_id
      pfm = parse_failure_message

      if pfm.size == 2
        pfm.last
      elsif parent.present?
        profile_id_from_parent
      end
    end

    def participant_profile
      return if participant_profile_id.nil?

      @participant_profile ||= Migration::ParticipantProfilePresenter.new(Migration::ParticipantProfile.find(participant_profile_id))
    end

    def parent
      return if parent_id.blank?

      Teacher.find(parent_id) if parent_type == "Teacher"
    end

    def related_object_id
      participant_profile_id || item["id"]
    end

  private

    def migration_failure
      __getobj__
    end

    def profile_id_from_parent
      return parent.legacy_ect_id if parent.legacy_ect_id.present?
      return parent.legacy_mentor_id if parent.legacy_mentor_id.present?

      if parent.legacy_id
        # NOTE: if they have both ECT and Mentor profiles we don't know which had the issue
        #       and we're only returning the first from the DB but it feels that might be better
        #       than nothing.
        Migration::User.find(parent.legacy_id).teacher_profile.participant_profiles.ect_or_mentor.first&.id
      end
    end

    def friendly_error_type(error_class)
      case error_class
      when "InductionRecordSanitizer::MultipleBlankEndDateError"
        "More than 1 end date is blank in the Induction records"
      when "InductionRecordSanitizer::MultipleActiveStatesError"
        "More that 1 induction record with an active induction status"
      when "InductionRecordSanitizer::StartDateAfterEndDateError"
        "An induction record has a start date later than the end date"
      when "InductionRecordSanitizer::InvalidDateSequenceError"
        "The induction record dates are not sequential"
      when "InductionRecordSanitizer::NoInductionRecordsError"
        "The profile does not have any induction records"
      else
        error_class
      end
    end

    def parse_failure_message
      # exception class and id of context record
      # currently only for induction record errors and participant_profile_id
      failure_message.split("|")
    end
  end
end
