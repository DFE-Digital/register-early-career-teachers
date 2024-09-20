class CreateSchoolRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :school_roles do |t|
      t.references :user, foreign_key: true
      t.references :school, foreign_key: true

      t.timestamps
    end
  end
end
