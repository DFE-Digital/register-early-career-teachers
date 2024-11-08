module Migrators
  class Teacher < Migrators::Base
    def self.record_count
      teachers.count
    end

    def self.model
      :teacher
    end

    def self.teachers
      ::Migration::TeacherProfile.where(id: ::Migration::ParticipantProfile.ect_or_mentor.select(:teacher_profile_id).distinct)
    end

    def self.reset!
      if Rails.application.config.enable_migration_testing
        ::Teacher.connection.execute("TRUNCATE #{::Teacher.table_name} RESTART IDENTITY CASCADE")
      end
    end

    def migrate!
      migrate(self.class.teachers.eager_load(:user)) do |teacher_profile|
        migrate_teacher!(teacher_profile:)
      end
    end

    def migrate_teacher!(teacher_profile:)
      trn = teacher_profile.trn
      full_name = teacher_profile.user.full_name

      teacher = Processors::Teacher.new(trn:, full_name:).process!

      teacher_profile
        .participant_profiles
        .ect_or_mentor
        .eager_load(induction_records: [induction_programme: [school_cohort: :school]])
        .find_each do |participant_profile|
          induction_records = InductionRecordSanitizer.new(induction_records: participant_profile.induction_records)
          induction_records.validate!

          if participant_profile.ect?
            Processors::ECT::SchoolPeriods.new(teacher:, induction_records:).process!
            Processors::ECT::TrainingPeriods.new(teacher:, induction_records:).process!
          else
            school_mentors = paricipant_profile.school_mentors
            Processors::Mentor::SchoolPeriods.new(teacher:, induction_records:, school_mentors:).process!
            Processors::Mentor::TrainingPeriods.new(teacher:, induction_records:).process!
          end
        end
    end
  end
end
