class AddLegacyProfileIdsToTeacher < ActiveRecord::Migration[7.2]
  def change
    change_table :teachers, bulk: true do |t|
      t.uuid :legacy_ect_id
      t.uuid :legacy_mentor_id
    end
  end
end
