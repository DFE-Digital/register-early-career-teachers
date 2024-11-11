module Processors
  module ECT
    class SchoolPeriods
      attr_reader :teacher, :school_periods

      def initialize(teacher:, school_periods:)
        @teacher = teacher
        @school_periods = school_periods
      end

      def process!
        school_periods.each do |period|
          school = School.find_by!(urn: period.urn)
          ::ECTAtSchoolPeriod.create!(teacher:,
                                      school:,
                                      started_on: period.start_date,
                                      finished_on: period.end_date,
                                      legacy_start_id: period.start_source_id,
                                      legacy_end_id: period.end_source_id)
        end
      end
    end
  end
end
