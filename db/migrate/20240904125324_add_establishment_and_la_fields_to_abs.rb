class AddEstablishmentAndLaFieldsToAbs < ActiveRecord::Migration[7.2]
  def change
    # rubocop:disable Rails/NotNullColumn, Rails/BulkChangeTable
    add_column :appropriate_bodies, :local_authority_code, :integer, null: false
    add_column :appropriate_bodies, :establishment_number, :integer, null: false
    add_column :appropriate_bodies, :establishment_id, :virtual, type: :string, as: %(local_authority_code::varchar || '/' || establishment_number::varchar), stored: true
    add_index :appropriate_bodies, %i[local_authority_code establishment_number], unique: true
    # rubocop:enable Rails/NotNullColumn, Rails/BulkChangeTable
  end
end
