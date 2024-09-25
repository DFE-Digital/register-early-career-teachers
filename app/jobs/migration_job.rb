class MigrationJob < ApplicationJob
  queue_as :high_priority

  def perform
    LegacyDataImporter.new.migrate!
  end
end
