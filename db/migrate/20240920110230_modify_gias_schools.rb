class ModifyGIASSchools < ActiveRecord::Migration[7.2]
  def change
    # rubocop:disable Rails/NotNullColumn
    change_table :gias_schools do |t|
      t.rename :school_status, :status

      t.remove :administrative_district, type: :string
      t.remove :establishment_type, type: :string
      t.remove :local_authority, type: :integer
      t.remove :phase, type: :string
      t.remove :section_41_approved, type: :boolean

      t.string :administrative_district_code, null: false
      t.string :administrative_district_name
      t.integer :easting, null: false
      t.integer :local_authority_code, null: false
      t.string :local_authority_name
      t.integer :northing, null: false
      t.integer :number, null: false
      t.integer :phase_code, null: false
      t.string :phase_name
      t.boolean :section_41_approved, null: false
      t.integer :type_code, null: false
      t.string :type_name
      t.integer :ukprn
      t.string :website

      t.index :name, unique: true
      t.index :ukprn, unique: true
    end

    add_foreign_key "schools", "gias_schools", column: "urn", primary_key: "urn"
    # rubocop:enable Rails/NotNullColumn
  end
end
