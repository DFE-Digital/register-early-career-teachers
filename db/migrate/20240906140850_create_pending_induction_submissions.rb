class CreatePendingInductionSubmissions < ActiveRecord::Migration[7.2]
  def change
    create_table :pending_induction_submissions do |t|
      t.references :appropriate_body, null: true, foreign_key: true
      t.string :establishment_id, limit: 8, null: true
      t.string :trn, null: false, limit: 7
      t.string :first_name, limit: 80
      t.string :last_name, limit: 80
      t.date :date_of_birth
      t.string :induction_status, limit: 16
      t.enum :induction_programme, enum_type: :induction_programme, null: false
      t.date :started_on
      t.date :finished_on
      t.integer :number_of_terms
      t.timestamps
    end
  end
end
