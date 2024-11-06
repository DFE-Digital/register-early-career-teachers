class MigratorJob < ApplicationJob
  queue_as :migration

  def perform(migrator:, worker:)
    migrator.migrate!(worker:)
  end
end
