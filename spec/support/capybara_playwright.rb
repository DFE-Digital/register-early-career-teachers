require 'capybara/rspec'
require 'capybara-playwright-driver'

class CapybaraNullDriver < Capybara::Driver::Base
  def needs_server?
    true
  end
end

Capybara.register_driver(:null) { CapybaraNullDriver.new }
Capybara.register_driver(:playwright) do |app|
  Capybara::Playwright::Driver.new(app, browser_type: :chromium, headless: true)
end
Capybara.default_max_wait_time = 15
Capybara.default_driver = :playwright
Capybara.save_path = 'tmp/capybara'
