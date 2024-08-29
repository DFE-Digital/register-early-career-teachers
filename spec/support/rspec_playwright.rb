require 'capybara'
require 'playwright'

module RSpecPlaywright
  PLAYWRIGHT_CLI_EXECUTABLE_PATH = "./node_modules/.bin/playwright".freeze

  # rubocop:disable Rails/SaveBang
  def self.start_browser(js: false)
    browser = Playwright.create(playwright_cli_executable_path: PLAYWRIGHT_CLI_EXECUTABLE_PATH)
                        .playwright
                        .chromium
                        .launch(headless: true)
    browser.new_page(baseURL: Capybara.current_session.server.base_url, javaScriptEnabled: js)
  end
  # rubocop:enable Rails/SaveBang

  def self.close_browsers
    RSpec.configuration.playwright_page_with_js_enabled&.context&.browser&.close
    RSpec.configuration.playwright_page_with_js_disabled&.context&.browser&.close
    RSpec.configuration.playwright_page_with_js_enabled = nil
    RSpec.configuration.playwright_page_with_js_disabled = nil
  end
end
