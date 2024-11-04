class RemoveECTAtSchoolPeriodIdFromInductionPeriods < ActiveRecord::Migration[7.2]
  def change
    remove_column :induction_periods, :ect_at_school_period_id, :integer
  end
end
