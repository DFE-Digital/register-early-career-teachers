class AddMigrationSourceIds < ActiveRecord::Migration[7.2]
  def change
    add_column :teachers, :legacy_id, :uuid

    add_column :ect_at_school_periods, :legacy_start_id, :uuid 
    add_column :ect_at_school_periods, :legacy_end_id, :uuid 

    add_column :mentor_at_school_periods, :legacy_start_id, :uuid 
    add_column :mentor_at_school_periods, :legacy_end_id, :uuid 

    add_column :mentorship_periods, :legacy_start_id, :uuid 
    add_column :mentorship_periods, :legacy_end_id, :uuid 

    add_column :training_periods, :legacy_start_id, :uuid 
    add_column :training_periods, :legacy_end_id, :uuid 
  end
end
