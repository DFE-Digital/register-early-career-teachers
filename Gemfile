source "https://rubygems.org"

ruby "3.3.4"

gem "rails", "~> 7.2.1"

gem "bootsnap", require: false
gem "cssbundling-rails"
gem "jsbundling-rails"
gem "pg", "~> 1.5"
gem "propshaft"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[windows jruby]

gem "govuk-components"
gem "govuk_design_system_formbuilder"
gem "govuk_markdown"

gem "mail-notify"

gem "solid_queue"

# DfE Sign-In
gem "omniauth"
gem 'omniauth_openid_connect'
gem 'omniauth-rails_csrf_protection'

# OTP Sign-in
gem "base32"
gem "rotp"

group :development, :test do
  gem "brakeman"
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails"
  gem "faker"
  gem "playwright-ruby-client"
  gem "rspec"
  gem "rspec-rails"
  gem "rubocop-govuk"
  gem "shoulda-matchers"
end

group :test do
  gem "capybara"
  gem "shoulda-matchers"
end

group :nanoc do
  gem "asciidoctor"
  gem "nanoc"
  gem "nanoc-live"
end
