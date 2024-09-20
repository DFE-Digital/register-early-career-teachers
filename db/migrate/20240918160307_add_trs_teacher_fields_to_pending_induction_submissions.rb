class AddTrsTeacherFieldsToPendingInductionSubmissions < ActiveRecord::Migration[7.2]
  def change
    change_table :pending_induction_submissions, bulk: true do |t|
      t.string :email_address
      t.jsonb :alerts
      t.date :induction_start_date
      t.string :induction_status_description
      t.boolean :qts_awarded
      t.string :qts_status_description
      t.date :initial_teacher_training_end_date
      t.string :initial_teacher_training_provider_name
    end
  end
end
