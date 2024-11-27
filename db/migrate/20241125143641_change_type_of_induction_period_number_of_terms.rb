class ChangeTypeOfInductionPeriodNumberOfTerms < ActiveRecord::Migration[7.2]
  def up
    change_column :induction_periods, :number_of_terms, :decimal, precision: 3, scale: 1
    change_column :pending_induction_submissions, :number_of_terms, :decimal, precision: 3, scale: 1
  end

  def down
    change_column :induction_periods, :number_of_terms, :integer
    change_column :pending_induction_submissions, :number_of_terms, :integer
  end
end
