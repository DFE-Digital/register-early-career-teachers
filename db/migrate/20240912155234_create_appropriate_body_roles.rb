class CreateAppropriateBodyRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :appropriate_body_roles do |t|
      t.references :user, foreign_key: true
      t.references :appropriate_body, foreign_key: true

      t.timestamps
    end
  end
end
