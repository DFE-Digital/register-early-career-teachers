class AddLegacyIdToAppropriateBodies < ActiveRecord::Migration[7.2]
  def change
    add_column :appropriate_bodies, :legacy_id, :uuid
  end
end
