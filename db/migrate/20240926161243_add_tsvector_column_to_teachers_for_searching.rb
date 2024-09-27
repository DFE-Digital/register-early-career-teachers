class AddTsvectorColumnToTeachersForSearching < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'pg_trgm'

    rename_column 'teachers', :name, :corrected_name

    # rubocop:disable Rails/ReversibleMigration
    change_column 'teachers', :corrected_name, :string, null: true
    # rubocop:enable Rails/ReversibleMigration

    change_table 'teachers', bulk: true do |t|
      # rubocop:disable Rails/NotNullColumn
      t.string :first_name, null: false
      t.string :last_name, null: false
      # rubocop:enable Rails/NotNullColumn

      tsvector_columns = %w[first_name last_name corrected_name].map { |col| "coalesce(#{col}, '')" }.join(" || ' ' || ")
      t.tsvector :search, type: :tsvector, as: "to_tsvector('english', #{tsvector_columns})", stored: true
    end

    add_index :teachers, :search, using: :gin
    add_index :teachers, %i[first_name last_name corrected_name], using: :gin, opclass: { first_name: :gin_trgm_ops, last_name: :gin_trgm_ops, corrected_name: :gin_trgm_ops }
  end
end
