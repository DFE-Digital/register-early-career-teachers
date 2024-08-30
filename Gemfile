source "https://rubygems.org"

ruby "3.3.4"

gem "rails", "~> 7.2.0"

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

group :development, :test do
  gem "brakeman"
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails"
  gem "faker"
  gem "playwright-ruby-client"
  gem "rspec"
  gem "rspec-rails"
  gem "rubocop-govuk"
end

group :nanoc do
  gem "asciidoctor"
  gem "nanoc"
  gem "nanoc-live"
end
