class AddTrsTeacherFieldsToPendingInductionSubmissions < ActiveRecord::Migration[7.2]
  def change
    change_table :pending_induction_submissions, bulk: true do |t|
      t.string :middle_name
      t.string :national_insurance_number
      t.string :email_address
      t.boolean :eyts_awarded
      t.string :eyts_certificate_url
      t.string :eyts_status_description
      t.jsonb :alerts
      t.date :induction_start_date
      t.date :induction_end_date
      t.string :induction_status_description
      t.string :induction_certificate_url
      t.boolean :pending_name_change
      t.boolean :pending_date_of_birth_change
      t.boolean :qts_awarded
      t.string :qts_certificate_url
      t.string :qts_status_description
      t.jsonb :initial_teacher_training
      t.jsonb :npq_qualifications
      t.jsonb :mandatory_qualifications
      t.jsonb :higher_education_qualifications
      t.jsonb :previous_names
      t.boolean :allow_id_sign_in_with_prohibitions
    end
  end
end
