class MigratorJob < ApplicationJob
  queue_as :high_priority

  def perform(migrator:, worker:)
    migrator.migrate!(worker:)
  end
end
