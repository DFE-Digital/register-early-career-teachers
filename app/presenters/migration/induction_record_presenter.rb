module Migration
  class InductionRecordPresenter < SimpleDelegator
    def self.wrap(induction_records)
      induction_records.map { |induction_record| new(induction_record) }
    end

    def pretty_start_date
      induction_record.start_date.to_date
    end

    def pretty_end_date
      return "" if induction_record.end_date.blank?

      induction_record.end_date.to_date
    end

    def lead_provider_name
      partnership&.lead_provider&.name
    end

    def delivery_partner_name
      partnership&.delivery_partner&.name
    end

    def cip_materials_name
      induction_programme.core_induction_programme&.name
    end

    def fip?
      training_programme == "full_induction_programme"
    end

    def cip?
      training_programme == "core_induction_programme"
    end

    def training_type
      training_programme.humanize
    end

    def appropriate_body_name
      induction_record.appropriate_body&.name || school_cohort.appropriate_body&.name
    end

    def mentor_name
      induction_record.mentor_profile&.teacher_profile&.user&.full_name || ""
    end

    delegate :name, to: :school, prefix: true
    delegate :urn, to: :school, prefix: true

    def school_name_and_urn
      "#{school_name} (#{school.urn})"
    end

    def participant_type
      induction_record.participant_profile.type.split("::").last
    end

    def ect_school_periods
      Migration::SchoolPeriodPresenter.wrap(
        fetch_migrated_periods_by_type(ECTAtSchoolPeriod)
      )
    end

    def mentor_school_periods
      Migration::SchoolPeriodPresenter.wrap(
        fetch_migrated_periods_by_type(MentorAtSchoolPeriod)
      )
    end

    def training_periods
      fetch_migrated_periods_by_type(TrainingPeriod)
    end

    def mentorship_periods
      fetch_migrated_periods_by_type(MentorshipPeriod)
    end

  private

    def induction_record
      __getobj__
    end

    def fetch_migrated_periods_by_type(klass)
      klass.where(legacy_start_id: id).or(klass.where(legacy_end_id: id)).order(:started_on)
    end

    def induction_programme
      @induction_programme ||= induction_record.induction_programme
    end

    def school_cohort
      @school_cohort ||= induction_programme.school_cohort
    end

    def school
      @school ||= school_cohort.school
    end

    def training_programme
      @training_programme ||= induction_programme.training_programme
    end

    def partnership
      @partnership ||= induction_programme.partnership
    end
  end
end
