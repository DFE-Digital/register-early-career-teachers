# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.enable_tracing = true
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.release = ENV["COMMIT_SHA"]
  config.traces_sample_rate = 0.1
end
