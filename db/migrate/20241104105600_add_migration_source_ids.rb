class AddMigrationSourceIds < ActiveRecord::Migration[7.2]
  def change
    add_column :teachers, :legacy_id, :uuid

    change_table :ect_at_school_periods, bulk: true do |t|
      t.uuid :legacy_start_id
      t.uuid :legacy_end_id
    end

    change_table :mentor_at_school_periods, bulk: true do |t|
      t.uuid :legacy_start_id
      t.uuid :legacy_end_id
    end

    change_table :mentorship_periods, bulk: true do |t|
      t.uuid :legacy_start_id
      t.uuid :legacy_end_id
    end

    change_table :training_periods, bulk: true do |t|
      t.uuid :legacy_start_id
      t.uuid :legacy_end_id
    end
  end
end
