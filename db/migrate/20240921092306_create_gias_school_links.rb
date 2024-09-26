class CreateGIASSchoolLinks < ActiveRecord::Migration[7.2]
  def change
    create_table :gias_school_links do |t|
      t.integer :urn, null: false, index: true
      t.integer :link_urn, null: false
      t.string :link_type, null: false
      t.date :link_date, null: false

      t.timestamps
    end

    add_foreign_key "gias_school_links", "gias_schools", column: "urn", primary_key: "urn"
    add_foreign_key "gias_school_links", "gias_schools", column: "link_urn", primary_key: "urn"
  end
end
