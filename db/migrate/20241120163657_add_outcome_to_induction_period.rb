class AddOutcomeToInductionPeriod < ActiveRecord::Migration[7.2]
  def change
    add_column :induction_periods, :outcome, :enum, enum_type: 'induction_outcomes', null: true
  end
end
