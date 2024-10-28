namespace :db do
  desc 'Add search config'
  task setup_search_configuration: :environment do
    Rails.logger.info("Setting up full text search unaccented configuration")
    command = <<~SQL
      create extension if not exists unaccent;

      create text search configuration unaccented ( copy = simple );

      alter text search configuration unaccented
        alter mapping for hword, hword_part, word
        with unaccent, simple;
    SQL

    Rails.logger.info("Adding full text search unaccented config to current env")
    ActiveRecord::Base.connection.execute(command)

    # NOTE: when we run this in the development env Rails automatically
    #       creates the test database too, but not via `db:create` so
    #       we need to ensure the text search config is applied there too
    if Rails.env.development?
      Rails.logger.info("Adding full text search unaccented config to test env")
      ActiveRecord::Base.establish_connection(:test)
      ActiveRecord::Base.connection.execute(command)
      ActiveRecord::Base.establish_connection(:development)
    end
  end
end

Rake::Task['db:schema:load'].enhance(['db:setup_search_configuration'])
