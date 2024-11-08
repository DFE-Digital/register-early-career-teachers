module Processors
  module ECT
    class SchoolPeriods

      attr_reader :teacher, :induction_records

      def initialize(teacher:, induction_records:)
        @teacher = teacher
        @induction_records = induction_records
      end

      def process!
        school_periods = SchoolPeriodExtractor.new(induction_records:)
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

    private

      def first_name
        parts = full_name.split(' ')
        if parts.count > 2 && parts.first.downcase.in?(%w[mr mr. miss ms ms. mrs mrs. dr dr.])
          parts.second
        else
          parts.first
        end
      end

      def last_name
        # FIXME: check for suffix titles perhaps e.g. Esq.
        full_name.split(' ').last
      end
    end
  end
end
