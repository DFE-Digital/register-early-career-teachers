class LegacyDataImporter
  attr_reader :logger

  def initialize
    @logger = Logger.new(Rails.root.join("log/import-#{Time.zone.now.strftime('%Y%m%d-%H%S')}"))
  end

  def prepare!
    migrators.each { |migrator| migrator.prepare! }
  end

  def migrate!
    migrators_in_dependency_order.each do |migrator|
      migrator.queue if migrator.runnable?
    end
  end

  def reset!
    # FIXME: could cause an issue if there are any jobs in process, plus do
    # we want to do this?
    DataMigration.all.each(&:destroy!)

    migrators_in_dependency_order.reverse.each do |migrator|
      migrator.reset!
    end
  end

private

  def migrators_in_dependency_order
    graph = migrators.to_h { |migrator| [migrator.model, migrator] }

    each_node = lambda { |&b| graph.each_key(&b) }
    each_child = lambda { |model, &b| graph[model].dependencies.each(&b) }

    TSort.strongly_connected_components(each_node, each_child).flatten.map { |key| graph[key] }
  end

  def migrators
    Rails.application.eager_load!
    Migrators::Base.descendants
  end
end
