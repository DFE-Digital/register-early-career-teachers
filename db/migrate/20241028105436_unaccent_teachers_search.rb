class UnaccentTeachersSearch < ActiveRecord::Migration[7.2]
  def down
    remove_column :teachers, :search, :tsvector, type: :tsvector, as: "to_tsvector('unaccented', #{tsvector_columns})", stored: true

    execute <<~SQL
      drop text search configuration unaccented;
    SQL

    disable_extension 'unaccent'

    add_column :teachers, :search, :tsvector, type: :tsvector, as: "to_tsvector('english', #{tsvector_columns})", stored: true
  end

  def up
    remove_column :teachers, :search, :tsvector, type: :tsvector, as: "to_tsvector('english', #{tsvector_columns})", stored: true

    enable_extension 'unaccent'

    execute <<~SQL
      create text search configuration unaccented ( copy = simple );
      alter text search configuration unaccented
        alter mapping for hword, hword_part, word
        with unaccent, simple;
    SQL

    add_column :teachers, :search, :tsvector, type: :tsvector, as: "to_tsvector('unaccented', #{tsvector_columns})", stored: true

    add_index :teachers, :search, using: :gin
  end

  def tsvector_columns
    %w[first_name last_name corrected_name].map { |col| "coalesce(#{col}, '')" }.join(" || ' ' || ")
  end
end
