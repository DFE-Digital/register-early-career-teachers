class Migration::FailuresController < ::AdminController
  layout "full"

  def index
    @pagy, failures = pagy(MigrationFailure.where(data_migration_id: DataMigration.where(model: params[:model]).select(:id)).order(:parent_id, :created_at))
    @migration_failures = Migration::MigrationFailurePresenter.wrap(failures)
    @model = params[:model]
  end
end
