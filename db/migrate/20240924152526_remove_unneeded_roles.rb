class RemoveUnneededRoles < ActiveRecord::Migration[7.2]
  def change
    # rubocop:disable Rails/ReversibleMigration
    # rubocop:disable Rails/NotNullColumn
    drop_table :lead_provider_roles
    drop_table :delivery_partner_roles
    drop_table :school_roles

    change_table :appropriate_body_roles, bulk: true do |t|
      t.remove :user_id
      t.remove :appropriate_body_id
      t.integer :user_id, null: false, index: true
      t.integer :appropriate_body_id, null: false, index: true
    end
    change_column :dfe_roles, :user_id, :integer, null: false
    # rubocop:enable Rails/ReversibleMigration Rails/NotNullColumn
    # rubocop:enable Rails/NotNullColumn
  end
end
