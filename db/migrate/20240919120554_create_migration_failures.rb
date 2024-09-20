class CreateMigrationFailures < ActiveRecord::Migration[7.2]
  def change
    create_table :migration_failures do |t|
      t.references :data_migration, index: true, null: false
      t.json :item, null: false
      t.string :failure_message
      t.timestamps
    end
  end
end
