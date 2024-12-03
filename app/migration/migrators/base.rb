module Migrators
  class ChildRecordError < StandardError
    attr_reader :parent

    def initialize(message, parent = nil)
      @parent = parent
      super(message)
    end
  end

  class Base
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :worker

    class << self
      def migrate!(args = {})
        new(**args).migrate!
      end

      def queue
        DataMigration.where(model:).update!(queued_at: Time.zone.now)

        number_of_workers.times do |worker|
          MigratorJob.perform_later(migrator: self, worker:)
        end
      end

      def prepare!
        number_of_workers.times do |worker|
          data_migration = DataMigration.create!(model:, worker:)
          FailureManager.purge_failures!(data_migration)
        end
      end

      def runnable?
        DataMigration.incomplete.where(model: dependencies).none? &&
          DataMigration.queued.where(model:).none?
      end

      def record_count
        raise NotImplementedError
      end

      def model
        raise NotImplementedError
      end

      def dependencies
        []
      end

      def number_of_workers
        [1, (record_count / records_per_worker.to_f).ceil].max
      end

      def records_per_worker
        5_000
      end

      def reset!
        raise NotImplementedError
      end

      def migrators
        load_descendants if descendants.empty?
        descendants
      end

      def migrators_in_dependency_order
        graph = migrators.index_by(&:model)

        each_node = ->(&b) { graph.each_key(&b) }
        each_child = ->(model, &b) { graph[model].dependencies.each(&b) }

        TSort.strongly_connected_components(each_node, each_child).flatten.map { |key| graph[key] }
      end

      def find_by_model(model)
        migrators.select { |migrator| migrator.model == model.to_sym }.first
      end

      def load_descendants
        Dir[File.join(__dir__, "*.rb")].each { |f| require f }
      end
    end

  protected

    def migrate(items)
      items = items.order(:id).offset(offset).limit(limit)

      start_migration!(items.count)

      # As we're using offset/limit, we can't use find_each!
      items.each do |item|
        yield(item)
        DataMigration.update_counters(data_migration.id, processed_count: 1)
      rescue ::Migrators::ChildRecordError => e
        DataMigration.update_counters(data_migration.id, failure_count: 1, processed_count: 1)
        failure_manager.record_child_failure(e.parent, item, e.message)
      rescue ActiveRecord::ActiveRecordError, ::InductionRecordSanitizer::InductionRecordError => e
        DataMigration.update_counters(data_migration.id, failure_count: 1, processed_count: 1)
        failure_manager.record_failure(item, e.message)
      end

      finalise_migration!
    end

    def run_once
      yield if worker.zero?
    end

    def failure_manager
      @failure_manager ||= FailureManager.new(data_migration:)
    end

    def data_migration
      @data_migration ||= DataMigration.find_by(model: self.class.model, worker:)
    end

  private

    def offset
      worker * self.class.records_per_worker
    end

    def limit
      # allow us to select a subset for testing if record_count is huge and we limit it
      [self.class.records_per_worker, self.class.record_count].min
    end

    def start_migration!(total_count)
      # We reset the processed/failure counts in case this is a retry.
      data_migration.update!(
        started_at: Time.zone.now,
        total_count:,
        processed_count: 0,
        failure_count: 0
      )
      log_info("Migration started")
    end

    def log_info(message)
      migration_details = data_migration.reload.attributes.slice(
        "model",
        "worker",
        "processed_count",
        "total_count"
      ).symbolize_keys
      # Rails.logger.info(message, migration_details)
      Rails.logger.info("#{message}: [#{migration_details}]")
    end

    def finalise_migration!
      data_migration.update!(completed_at: 1.second.from_now)
      log_info("Migration completed")

      return unless DataMigration.incomplete.where(model: self.class.model).none?

      # Queue a follow up migration to migrate any
      # dependent models.
      MigrationJob.perform_later
    end
  end
end
