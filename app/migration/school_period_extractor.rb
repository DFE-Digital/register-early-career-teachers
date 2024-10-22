class SchoolPeriodExtractor
  include Enumerable

  def initialize(induction_records:)
    @induction_records = induction_records
  end

  def each(&block)
    return to_enum(__method__) { school_periods.size } unless block_given?

    school_periods.each(&block)
  end

private

  def school_periods
    @school_periods ||= build_school_periods
  end

  def build_school_periods
    current_period = nil
    current_school = nil

    school_period = Struct.new(:urn, :start_date, :end_date)

    @induction_records.each_with_object([]) do |induction_record, periods|
      record_school = induction_record.induction_programme.school_cohort.school

      if current_school != record_school
        current_school = record_school

        current_period = school_period.new(urn: current_school.urn,
                                           start_date: induction_record.start_date,
                                           end_date: induction_record.end_date)
        periods << current_period
      else
        current_period.end_date = induction_record.end_date
      end
    end
  end
end
