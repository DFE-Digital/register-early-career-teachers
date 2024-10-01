class AddSubmissionTimestampToTeacher < ActiveRecord::Migration[7.2]
  def change
    add_column :teachers, :induction_start_date_submitted_to_trs_at, :datetime
  end
end
