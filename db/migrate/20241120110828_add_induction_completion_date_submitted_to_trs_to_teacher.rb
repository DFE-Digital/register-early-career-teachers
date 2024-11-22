class AddInductionCompletionDateSubmittedToTRSToTeacher < ActiveRecord::Migration[7.2]
  def change
    add_column :teachers, :induction_completion_submitted_to_trs_at, :datetime
  end
end
