class UpdateTeacherSearchToBeUnaccented < ActiveRecord::Migration[7.2]
  def up
    enable_extension 'unaccent'

    # Remove existing search column and its index
    remove_index :teachers, :search
    remove_column :teachers, :search

    # Add back the search column as a regular column
    add_column :teachers, :search, :tsvector

    # Create trigger function
    execute <<-SQL
      CREATE OR REPLACE FUNCTION teachers_search_trigger()
      RETURNS trigger AS $$
      BEGIN
        NEW.search := to_tsvector('english',
          unaccent(coalesce(NEW.first_name, '')) || ' ' ||
          unaccent(coalesce(NEW.last_name, '')) || ' ' ||
          unaccent(coalesce(NEW.corrected_name, ''))
        );
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL

    # Create trigger
    execute <<-SQL
      CREATE TRIGGER teachers_search_update
      BEFORE INSERT OR UPDATE OF first_name, last_name, corrected_name
      ON teachers
      FOR EACH ROW
      EXECUTE FUNCTION teachers_search_trigger();
    SQL

    # Update existing records
    execute <<-SQL
      UPDATE teachers
      SET search = to_tsvector('english',
        unaccent(coalesce(first_name, '')) || ' ' ||
        unaccent(coalesce(last_name, '')) || ' ' ||
        unaccent(coalesce(corrected_name, ''))
      );
    SQL

    # Add back the index
    add_index :teachers, :search, using: :gin
  end

  def down
    execute "DROP TRIGGER IF EXISTS teachers_search_update ON teachers;"
    execute "DROP FUNCTION IF EXISTS teachers_search_trigger();"

    remove_index :teachers, :search
    remove_column :teachers, :search

    # Recreate original search column
    change_table 'teachers', bulk: true do |t|
      tsvector_columns = %w[first_name last_name corrected_name].map { |col| "coalesce(#{col}, '')" }.join(" || ' ' || ")
      t.tsvector :search, type: :tsvector, as: "to_tsvector('english', #{tsvector_columns})", stored: true
    end

    add_index :teachers, :search, using: :gin
  end
end
