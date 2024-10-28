class AddTRSTeacherFieldsToPendingInductionSubmissions < ActiveRecord::Migration[7.2]
  def change
    change_table :pending_induction_submissions, bulk: true do |t|
      t.string :trs_email_address
      t.jsonb :trs_alerts
      t.date :trs_induction_start_date
      t.string :trs_induction_status_description
      t.boolean :trs_qts_awarded
      t.string :trs_qts_status_description
      t.date :trs_initial_teacher_training_end_date
      t.string :trs_initial_teacher_training_provider_name
    end

    rename_column :pending_induction_submissions, :first_name, :trs_first_name
    rename_column :pending_induction_submissions, :last_name, :trs_last_name
    rename_column :pending_induction_submissions, :induction_status, :trs_induction_status
  end
end
