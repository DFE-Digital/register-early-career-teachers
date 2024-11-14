class AddSearchColumnToGIASSchools < ActiveRecord::Migration[7.2]
  def change
    add_column :gias_schools, :search, :tsvector, type: :tsvector, as: "to_tsvector('unaccented', #{search_columns})", stored: true
    add_index :gias_schools, :search, using: :gin
  end

  def search_columns
    %w[name postcode urn].map { |col| "coalesce(#{col}::text, '')" }.join(" || ' ' || ")
  end
end
