class AddDataMigration < ActiveRecord::Migration[7.2]
  def change
    create_table :data_migrations do |t|
      t.string :model, null: false
      t.integer :processed_count, null: false, default: 0
      t.integer :failure_count, null: false, default: 0
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :total_count
      t.datetime :queued_at
      t.integer :worker

      t.timestamps
    end
  end
end
