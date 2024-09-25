class MigrationFailure < ApplicationRecord
  belongs_to :data_migration

  validates :item, presence: true
  validates :failure_message, presence: true
end
