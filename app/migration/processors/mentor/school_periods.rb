module Processors
  module Mentor
    class SchoolPeriods

      attr_reader :teacher, :induction_record, :school_mentors

      def initialize(teacher:, induction_records:, school_mentors:)
        @teacher = teacher
        @induction_records = induction_records
        @school_mentors = school_mentors
      end

      def process!
        process_school_periods!
        process_school_mentor_pools!
      end

    private

      def process_school_periods!
        school_periods = SchoolPeriodExtractor.new(induction_records:)
        school_periods.each do |period|
          school = School.find_by!(urn: period.urn)
          ::MentorAtSchoolPeriod.create!(teacher:,
                                         school:,
                                         started_on: period.start_date,
                                         finished_on: period.end_date,
                                         legacy_start_id: period.start_source_id,
                                         legacy_end_id: period.end_source_id)
        end
      end

      def process_school_mentor_pools!
        school_mentors.each do |school_mentor|
          school = School.find_by!(urn: school_mentor.school.urn)
          started_on = school_mentor.created_at

          periods = ::MentorAtSchoolPeriod.where(teacher:, school:)
          if periods.empty?
            ::MentorAtSchoolPeriod.create!(teacher:, school:, started_on:, legacy_start_id: school_mentor.id)
          end
        end
      end
    end
  end
end
