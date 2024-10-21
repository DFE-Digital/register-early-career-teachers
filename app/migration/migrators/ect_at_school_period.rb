module Migrators
  class ECTAtSchoolPeriod < Migrators::Base
    def self.record_count
      ects.count
    end

    def self.model
      :ect_at_school_period
    end

    def self.ects
      ::Migration::ParticipantProfile.ect.joins(:teacher_profile).where.not(teacher_profile: { trn: nil })
    end

    def self.dependencies
      %i[teacher]
    end

    def self.reset!
      if Rails.application.config.enable_migration_testing
        ActiveRecord::Base.connection.execute("TRUNCATE #{::ECTAtSchoolPeriod.table_name} RESTART IDENTITY CASCADE")
      end
    end

    def migrate!
      Rails.logger.info("Migrating #{self.class.record_count} early career teachers")

      migrate(self.class.ects.includes(:induction_records, :teacher_profile, teacher_profile: :user)) do |participant_profile|
        Rails.logger.info("  --> #{participant_profile.id}")

        teacher = ::Teacher.find_by!(trn: participant_profile.teacher_profile.trn)

        induction_records = InductionRecordSanitizer.new(participant_profile:)
        induction_records.validate!

        school_periods = SchoolPeriodExtractor.new(induction_records:)
        Rails.logger.info("--> migrating #{school_periods.count} school periods")
        school_periods.each do |period|
          school = School.find_by!(urn: period[:school].urn)
          ::ECTAtSchoolPeriod.create!(teacher:, school:, started_on: period[:start_date], finished_on: period[:end_date])
        end
      end
    end
  end
end
