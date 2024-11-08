module Migrators
  class TrainingPeriod < Migrators::Base
    def self.record_count
      profiles.count
    end

    def self.model
      :training_period
    end

    def self.profiles
      ::Migration::ParticipantProfile.ect_or_mentor.joins(:teacher_profile).where.not(teacher_profile: { trn: nil })
    end

    def self.reset!
      if Rails.application.config.enable_migration_testing
        ::Teacher.connection.execute("TRUNCATE #{::TrainingPeriod.table_name} RESTART IDENTITY CASCADE")
      end
    end

    def migrate!
      migrate(self.class.profiles.eager_load([induction_records: [induction_programme: :partnership]])) do |participant_profile|
        migrate_training_periods!(participant_profile:)
      end
    end

    def migrate_training_periods!(participant_profile:)
      teacher = ::Teacher.find_by!(trn: participant_profile.teacher_profile.trn)

      induction_records = InductionRecordSanitizer.new(participant_profile:)
      induction_records.validate!

      training_periods = TrainingPeriodExtractor.new(induction_records:)
      training_periods.each do |period|
        next unless period.training_programme == "full_induction_programme"

        provider_partnership = ::ProviderPartnership.where(lead_provider: ::LeadProvider.find_by!(name: period.lead_provider),
                                                           delivery_partner: ::DeliveryPartner.find_by!(name: period.delivery_partner),
                                                           academic_year_id: period.cohort_year).first

        ect_at_school_period = mentor_at_school_period = nil

        period_dates = OpenStruct.new(started_on: period.start_date, finished_on: period.end_date)
        if participant_profile.ect?
          ect_at_school_period = teacher.ect_at_school_periods.containing_period(period_dates).first
        else
          mentor_at_school_period = teacher.mentor_at_school_periods.containing_period(period_dates).first
        end

        tp = ::TrainingPeriod.create!(provider_partnership:,
                                      ect_at_school_period:,
                                      mentor_at_school_period:,
                                      started_on: period.start_date,
                                      finished_on: period.end_date,
                                      legacy_start_id: period.start_source_id,
                                      legacy_end_id: period.end_source_id)

      end
    end
  end
end
