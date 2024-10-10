module Ecf2
  class Application < Rails::Application
    config.enable_personas = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_PERSONAS', false))
  end
end
