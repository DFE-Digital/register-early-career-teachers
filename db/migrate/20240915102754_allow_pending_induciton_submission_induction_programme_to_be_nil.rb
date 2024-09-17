class AllowPendingInducitonSubmissionInductionProgrammeToBeNil < ActiveRecord::Migration[7.2]
  def up
    change_column :pending_induction_submissions, :induction_programme, :enum, null: true, enum_type: "induction_programme"
  end

  def down
    change_column :pending_induction_submissions, :induction_programme, :enum, null: false, enum_type: "induction_programme"
  end
end
