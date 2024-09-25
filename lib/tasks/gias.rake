namespace :gias do
  desc "Import schools data from Get Information About Schools"
  task import: :environment do
    logger = Logger.new($stdout)
    logger.info "Importing GIAS schools data, this may take a couple minutes..."
    GIAS::Schools::Importer.new.fetch
    logger.info "GIAS schools data import complete!"
  end
end
