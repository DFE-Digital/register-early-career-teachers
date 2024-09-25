class LegacyDataImporter
  def prepare!
    migrators.each(&:prepare!)
  end

  def migrate!
    migrators_in_dependency_order.each do |migrator|
      migrator.queue if migrator.runnable?
    end
  end

  def reset!
    # FIXME: could cause an issue if there are any jobs in process, plus do
    # we want to do this?
    DataMigration.all.find_each(&:destroy!)

    migrators_in_dependency_order.reverse.each(&:reset!)
  end

private

  def migrators_in_dependency_order
    graph = migrators.index_by(&:model)

    each_node = ->(&b) { graph.each_key(&b) }
    each_child = ->(model, &b) { graph[model].dependencies.each(&b) }

    TSort.strongly_connected_components(each_node, each_child).flatten.map { |key| graph[key] }
  end

  def migrators
    Rails.application.eager_load!
    Migrators::Base.descendants
  end
end
