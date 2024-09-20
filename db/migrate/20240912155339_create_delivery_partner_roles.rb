class CreateDeliveryPartnerRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :delivery_partner_roles do |t|
      t.references :user, foreign_key: true
      t.references :delivery_partner, foreign_key: true

      t.timestamps
    end
  end
end
