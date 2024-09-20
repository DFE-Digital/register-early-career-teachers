class FailureManager
  class << self
    def combine_failures(data_migrations)
      data_migrations.map do |data_migration|
        new(data_migration:).all_failures_hash
      end
      # data_migrations
      #   .map { |data_migration| new(data_migration:).all_failures_hash }
      #   .each_with_object({}) { |failure_hash, hash|
      #     failure_hash.each do |failure_key, failure_values|
      #       hash[failure_key] ||= []
      #       hash[failure_key] += failure_values
      #     end
      #   }
          # .to_json
    end

    def purge_failures!(data_migration)
      data_migration.migration_failures.delete_all
    end

    def migration_failure_key(data_migration)
      "migration_failure_#{data_migration.model}_#{data_migration.id}"
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
    failures = {}
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
