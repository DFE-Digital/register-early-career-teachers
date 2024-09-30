class AllowNilECTAtSchoolPeriodOnInductionPeriods < ActiveRecord::Migration[7.2]
  def change
    change_column_null :induction_periods, :ect_at_school_period_id, true
  end
end
