module Migrators
  class MentorshipPeriod < Migrators::Base
    def self.record_count
      ects.count
    end

    def self.model
      :mentorship_period
    end

    def self.ects
      ::Migration::ParticipantProfile.ect
    end

    def self.dependencies
      %i[teacher]
    end

    def self.reset!
      if Rails.application.config.enable_migration_testing
        ::MentorshipPeriod.connection.execute("TRUNCATE #{::MentorshipPeriod.table_name} RESTART IDENTITY CASCADE")
      end
    end

    def migrate!
      migrate(self.class.ects) do |participant_profile|
        migrate_mentorships!(participant_profile:)
      end
    end

    def migrate_mentorships!(participant_profile:)
      teacher = ::Teacher.find_by!(legacy_ect_id: participant_profile.id)
      induction_records = InductionRecordSanitizer.new(participant_profile:)
      induction_records.validate!

      mentorship_period_data = MentorshipPeriodExtractor.new(induction_records:)

      Builders::MentorshipPeriods.new(teacher:, mentorship_period_data:).process!
    end
  end
end
