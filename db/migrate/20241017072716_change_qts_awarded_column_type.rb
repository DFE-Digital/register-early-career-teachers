class ChangeQtsAwardedColumnType < ActiveRecord::Migration[7.2]
  def up
    change_table :pending_induction_submissions, bulk: true do |t|
      t.remove :trs_qts_awarded, type: :boolean
      t.date :trs_qts_awarded
    end
  end

  def down
    change_table :pending_induction_submissions, bulk: true do |t|
      t.remove :trs_qts_awarded, type: :date
      t.boolean :trs_qts_awarded
    end
  end
end
