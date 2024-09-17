class AddConfirmationFieldsToPendingInductionSubmissions < ActiveRecord::Migration[7.2]
  def change
    add_column :pending_induction_submissions, :confirmed_at, :datetime, null: true
  end
end
