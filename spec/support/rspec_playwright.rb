require 'playwright'

module RSpecPlaywright
  PLAYWRIGHT_CLI_EXECUTABLE_PATH = "./node_modules/.bin/playwright".freeze

  # rubocop:disable Rails/SaveBang
  def self.start_browser
    browser = Playwright.create(playwright_cli_executable_path: PLAYWRIGHT_CLI_EXECUTABLE_PATH)
                        .playwright
                        .chromium
                        .launch(headless: true)
    browser.new_page(baseURL: Capybara.current_session.server.base_url)
  end
  # rubocop:enable Rails/SaveBang

  def self.close_browser
    RSpec.configuration.playwright_page&.context&.browser&.close
    RSpec.configuration.playwright_page = nil
  end
end
