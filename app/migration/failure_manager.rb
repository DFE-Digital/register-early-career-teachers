class FailureManager
  class << self
    def combine_failures(data_migrations)
      data_migrations.map do |data_migration|
        new(data_migration:).all_failures_hash
      end
    end

    def purge_failures!(data_migration)
      data_migration.migration_failures.delete_all
    end
  end

  def record_failure(item, failure_message)
    return if item.blank?

    write_failure(item, failure_message)
  end

  def all_failures
    failures
  end

  def all_failures_hash
    data_migration.migration_failures.to_h do |failure|
      [
        failure.item["id"],
        {
          item: failure.item,
          message: failure.failure_message
        }
      ]
    end
  end

private

  attr_reader :data_migration

  def initialize(data_migration:)
    raise ArgumentError, "Missing data_migration" unless data_migration

    @data_migration = data_migration
  end

  def failures
    data_migration.migration_failures
  end

  def write_failure(item, failure_message)
    data_migration.migration_failures.create!(item: item.serializable_hash, failure_message:)
  end
end
