class CreateDfeRoles < ActiveRecord::Migration[7.2]
  def change
    create_enum :dfe_role_type, %w[admin super_admin finance]

    create_table :dfe_roles do |t|
      t.enum :role_type, enum_type: :dfe_role_type, default: "admin", null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
