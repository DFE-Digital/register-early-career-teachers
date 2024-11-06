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
      teacher = ::Teacher.create!(trn: teacher_profile.trn,
                                  first_name: first_name_of(teacher_profile.user.full_name),
                                  last_name: last_name_of(teacher_profile.user.full_name),
                                  legacy_id: teacher_profile.user.id)

      teacher_profile.participant_profiles
        .ect_or_mentor
        .eager_load(induction_records: [induction_programme: [school_cohort: :school]])
        .find_each do |participant_profile|
          migrate_participant_profile_for!(teacher:, participant_profile:)
        end
    end

    def migrate_participant_profile_for!(teacher:, participant_profile:)
      induction_records = InductionRecordSanitizer.new(participant_profile:)
      induction_records.validate!

      school_periods = SchoolPeriodExtractor.new(induction_records:)
      school_periods.each do |period|
        school = School.find_by!(urn: period.urn)
        attrs = {
          teacher:,
          school:,
          started_on: period.start_date,
          finished_on: period.end_date,
          legacy_start_id: period.start_source_id,
          legacy_end_id: period.end_source_id,
        }

        if participant_profile.ect?
          ::ECTAtSchoolPeriod.create!(**attrs)
        else
          ::MentorAtSchoolPeriod.create!(**attrs)
        end
      end

      if participant_profile.mentor?
        participant_profile.school_mentors.each do |school_mentor|
          school = School.find_by!(urn: school_mentor.school.urn)
          started_on = school_mentor.created_at

          periods = ::MentorAtSchoolPeriod.where(teacher:, school:)
          if periods.empty?
            # TODO: do we want to have a different model id (SchoolMentor instead of InductionRecord) in the legacy_start_id?
            ::MentorAtSchoolPeriod.create!(teacher:, school:, started_on:, legacy_start_id: school_mentor.id)
          end
        end
      end
    end

    def first_name_of(full_name)
      parts = full_name.split(' ')
      if parts.count > 2 && parts.first.downcase.in?(%w[mr mr. miss ms ms. mrs mrs. dr dr.])
        parts.second
      else
        parts.first
      end
    end

    def last_name_of(full_name)
      # FIXME: check for suffix titles perhaps e.g. Esq.
      full_name.split(' ').last
    end
  end
end
