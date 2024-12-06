require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module ECF2
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.assets.paths << Rails.root.join('node_modules/govuk-frontend/dist/govuk/assets')
    config.exceptions_app = routes
    config.active_record.belongs_to_required_by_default = false
    config.generators.system_tests = nil
    config.action_mailer.deliver_later_queue_name = "mailers"

    config.generators do |g|
      g.helper(false)
      g.factory_bot(suffix: "factory")
      g.test_framework(:rspec,
                       fixtures: false,
                       view_specs: false,
                       controller_specs: false,
                       helper_specs: false)
    end

    config.enable_personas = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_PERSONAS'))
    config.enable_persona_avatars = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_PERSONA_AVATARS', true))
    config.enable_migration_testing = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_MIGRATION_TESTING', false))
    config.enable_schools_interface = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_SCHOOLS_INTERFACE', false))
    config.enable_local_tls = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_LOCAL_TLS', false))
    config.enable_sentry = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_SENTRY', false))
    config.enable_blazer = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_BLAZER', false))
    config.sentry_dsn = ENV['SENTRY_DSN']

    config.dfe_sign_in_client_id = ENV['DFE_SIGN_IN_CLIENT_ID']
    config.dfe_sign_in_secret = ENV['DFE_SIGN_IN_SECRET']
    config.dfe_sign_in_redirect_uri = ENV['DFE_SIGN_IN_REDIRECT_URI']
    config.dfe_sign_in_issuer = ENV['DFE_SIGN_IN_ISSUER']
    config.dfe_sign_in_enabled = [config.dfe_sign_in_client_id,
                                  config.dfe_sign_in_secret,
                                  config.dfe_sign_in_redirect_uri,
                                  config.dfe_sign_in_issuer].all?

    config.after_initialize do
      ActionView::Base.default_form_builder = GOVUKDesignSystemFormBuilder::FormBuilder
    end
  end
end
