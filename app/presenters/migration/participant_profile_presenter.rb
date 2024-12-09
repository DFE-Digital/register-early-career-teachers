module Migration
  class ParticipantProfilePresenter < SimpleDelegator
    def self.wrap(collection)
      collection.map { |participant_profile| new(participant_profile) }
    end

    def participant_type
      participant_profile.type.split("::").last
    end

    def induction_records
      @induction_records ||= fetch_induction_records
    end

  private

    def participant_profile
      __getobj__
    end

    def fetch_induction_records
      Migration::InductionRecordPresenter.wrap(
        participant_profile.induction_records.order(start_date: :asc)
      )
    end
  end
end
