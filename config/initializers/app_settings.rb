module Ecf2
  class Application < Rails::Application
    config.enable_personas = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_PERSONAS', false))
    config.enable_migration_testing = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_MIGRATION_TESTING', false))
  end
end
