class MigrationJob < ApplicationJob
  queue_as :migration

  def perform
    LegacyDataImporter.new.migrate!
  end
end
