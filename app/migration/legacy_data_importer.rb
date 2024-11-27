class LegacyDataImporter
  def prepare!
    Migrators::Base.migrators.each(&:prepare!)
  end

  def migrate!
    Migrators::Base.migrators_in_dependency_order.each do |migrator|
      migrator.queue if migrator.runnable?
    end
  end

  def reset!
    # FIXME: could cause an issue if there are any jobs in process, plus do
    # we want to do this?
    DataMigration.all.find_each(&:destroy!)

    Migrators::Base.migrators_in_dependency_order.reverse.each(&:reset!)
  end
end
