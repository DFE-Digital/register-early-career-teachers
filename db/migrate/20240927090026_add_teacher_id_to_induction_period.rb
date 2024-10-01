class AddTeacherIdToInductionPeriod < ActiveRecord::Migration[7.2]
  def change
    add_reference :induction_periods, :teacher, foreign_key: true
  end
end
