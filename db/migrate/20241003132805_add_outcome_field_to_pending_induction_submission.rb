class AddOutcomeFieldToPendingInductionSubmission < ActiveRecord::Migration[7.2]
  def change
    create_enum 'induction_outcomes', %w[fail pass]

    add_column 'pending_induction_submissions', 'outcome', 'enum', enum_type: 'induction_outcomes', null: true
  end
end
