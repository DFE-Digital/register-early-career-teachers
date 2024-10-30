class AddExtensionsTable < ActiveRecord::Migration[7.2]
  def change
    create_table :induction_extensions do |t|
      t.references :teacher, null: false, foreign_key: true
      t.decimal :extension_terms, precision: 2, scale: 1, null: false

      t.timestamps
    end
  end
end
