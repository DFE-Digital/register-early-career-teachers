class AddTRNToTeachers < ActiveRecord::Migration[7.2]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :teachers, :trn, :string, null: false
    add_index :teachers, :trn, unique: true
    # rubocop:enable Rails/NotNullColumn
  end
end
