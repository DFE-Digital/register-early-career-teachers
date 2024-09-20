class CreateLeadProviderRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :lead_provider_roles do |t|
      t.references :user, foreign_key: true
      t.references :lead_provider, foreign_key: true

      t.timestamps
    end
  end
end
