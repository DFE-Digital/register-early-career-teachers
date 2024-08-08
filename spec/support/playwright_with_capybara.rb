require 'capybara'
require 'playwright'

class CapybaraNullDriver < Capybara::Driver::Base
  def needs_server?
    true
  end
end

RSpec.configure do |config|
  Capybara.register_driver(:null) { CapybaraNullDriver.new }

  config.around(driver: :null) do |example|
    Capybara.current_driver = :null

    # Rails server is launched here, at the first time of accessing Capybara.current_session.server
    base_url = Capybara.current_session.server.base_url

    Playwright.create(playwright_cli_executable_path: './node_modules/.bin/playwright') do |playwright|
      # pass any option for Playwright#launch and Browser#new_page as you prefer.
      playwright.chromium.launch(headless: true) do |browser|
        @playwright_page = browser.new_page(baseURL: base_url)
        example.run
      end
    end
  end
end
