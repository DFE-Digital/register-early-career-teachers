module PeriodHelpers
  class PeriodExamples
    def self.period_examples
      [
        OpenStruct.new(
          description: 'when the existing period contains the new one',
          existing_period_range: 4.months.ago.to_date..1.month.ago.to_date,
          new_period_range: 3.months.ago.to_date..2.months.ago.to_date,
          expected_valid: false
        ),
        OpenStruct.new(
          description: 'when the new period starts before the existing one has finished',
          existing_period_range: 4.months.ago.to_date..2.months.ago.to_date,
          new_period_range: 3.months.ago.to_date..1.month.ago.to_date,
          expected_valid: false
        ),
        OpenStruct.new(
          description: 'when the new period finishes after the existing one has started',
          existing_period_range: 4.months.ago.to_date..2.months.ago.to_date,
          new_period_range: 5.months.ago.to_date..3.months.ago.to_date,
          expected_valid: false
        ),
        OpenStruct.new(
          description: 'when the later period starts on the day the former one finishes',
          existing_period_range: 4.months.ago.to_date..1.month.ago.to_date,
          new_period_range: 1.month.ago.to_date..1.week.ago.to_date,
          expected_valid: true
        ),
        OpenStruct.new(
          description: 'when the periods are entirely separate',
          existing_period_range: 4.months.ago.to_date..2.months.ago.to_date,
          new_period_range: 1.month.ago.to_date..1.week.ago.to_date,
          expected_valid: true
        )
      ]
    end
  end
end
