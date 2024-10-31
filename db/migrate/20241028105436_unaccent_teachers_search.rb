class UnaccentTeachersSearch < ActiveRecord::Migration[7.2]
  def down
    # rubocop:disable Rails/BulkChangeTable
    remove_column :teachers, :search, :tsvector, type: :tsvector, as: "to_tsvector('unaccented', #{tsvector_columns})", stored: true
    add_column :teachers, :search, :tsvector, type: :tsvector, as: "to_tsvector('english', #{tsvector_columns})", stored: true
    add_index :teachers, :search, using: :gin
    # rubocop:enable Rails/BulkChangeTable
  end

  def up
    # rubocop:disable Rails/BulkChangeTable
    remove_column :teachers, :search, :tsvector, type: :tsvector, as: "to_tsvector('english', #{tsvector_columns})", stored: true
    add_column :teachers, :search, :tsvector, type: :tsvector, as: "to_tsvector('unaccented', #{tsvector_columns})", stored: true
    add_index :teachers, :search, using: :gin
    # rubocop:enable Rails/BulkChangeTable
  end

  def tsvector_columns
    %w[first_name last_name corrected_name].map { |col| "coalesce(#{col}, '')" }.join(" || ' ' || ")
  end
end
