class AddParentIdToMigrationFailure < ActiveRecord::Migration[7.2]
  def change
    change_table :migration_failures, bulk: true do |t|
      t.integer :parent_id, null: true, index: true
      t.string :parent_type, null: true
    end
  end
end
