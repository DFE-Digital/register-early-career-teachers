class Migration::MigrationsController < ::AdminController
  def index
    @data_migrations = DataMigration.order(model: :asc, worker: :asc).all
    @in_progress_migration = @data_migrations.present? && !@data_migrations.all?(&:complete?)
    @completed_migration = @data_migrations.present? && @data_migrations.all?(&:complete?)
  end

  def create
    LegacyDataImporter.new.prepare!
    MigrationJob.perform_later

    redirect_to migration_path
  end

  def reset
    LegacyDataImporter.new.reset!
    redirect_to migration_path
  end

  def download_report
    data_migrations = DataMigration.complete.where(model: params[:model])
    failures = FailureManager.combine_failures(data_migrations)

    send_data(failures.to_json, filename: "migration_failures_#{params[:model]}.json", type: :json, disposition: "attachment")
  end
end
