module Migrators
  class MentorAtSchoolPeriod < Migrators::Base
    def self.record_count
      mentors.count
    end

    def self.model
      :mentor_at_school_period
    end

    def self.mentors
      ::Migration::ParticipantProfile.mentor.joins(:teacher_profile).where.not(teacher_profile: { trn: nil })
    end

    def self.dependencies
      %i[teacher]
    end

    def self.reset!
      if Rails.application.config.enable_migration_testing
        ActiveRecord::Base.connection.execute("TRUNCATE #{::MentorAtSchoolPeriod.table_name} RESTART IDENTITY CASCADE")
      end
    end

    def migrate!
      Rails.logger.info("Migrating #{self.class.record_count} mentors")

      migrate(self.class.mentors.eager_load(:teacher_profile, :school_mentors, induction_records: [induction_programme: [school_cohort: :school]])) do |participant_profile|
        Rails.logger.info("  --> #{participant_profile.id}")

        teacher = ::Teacher.find_by!(trn: participant_profile.teacher_profile.trn)

        induction_records = InductionRecordSanitizer.new(participant_profile:)
        induction_records.validate!

        school_periods = SchoolPeriodExtractor.new(induction_records:)
        Rails.logger.info("--> migrating #{school_periods.count} school periods")
        school_periods.each do |period|
          school = School.find_by!(urn: period.urn)
          ::MentorAtSchoolPeriod.create!(teacher:, school:, started_on: period.start_date, finished_on: period.end_date)
        end

        participant_profile.school_mentors.each do |school_mentor|
          school = School.find_by!(urn: school_mentor.school.urn)
          started_on = school_mentor.created_at

          periods = ::MentorAtSchoolPeriod.where(teacher:, school:)
          if periods.empty?
            Rails.logger.info("--> migrating from school mentor pool at #{school.urn}")
            ::MentorAtSchoolPeriod.create!(teacher:, school:, started_on:)
          end
        end
      end
    end
  end
end
