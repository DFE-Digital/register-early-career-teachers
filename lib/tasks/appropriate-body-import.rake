namespace :appropriate_body do
  desc "Import Appropriate Body data from the old AB Portal"
  task import: :environment do
    logger = Logger.new($stdout)
    logger.info "Checking files exist"
    logger.info "Importing Appropriate Body records"
    imported_abs = AppropriateBodies::Importers::AppropriateBodyImporter.new.import
    logger.info "#{imported_abs} Appropriate Body records imported"
  end
end
