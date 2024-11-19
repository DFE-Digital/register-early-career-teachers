require 'capybara'
require 'playwright'

module RSpecPlaywright
  DEFAULT_TIMEOUT = 3_000
  PLAYWRIGHT_CLI_EXECUTABLE_PATH = "./node_modules/.bin/playwright".freeze

  # rubocop:disable Rails/SaveBang
  def self.start_browser(javascript_enabled: false)
    headless = ENV.fetch('HEADLESS', true).then do |h|
      case
      when h.in?([true, '1', 'yes', 'true'])
        true
      when h.in?([false, '0', 'no', 'false'])
        false
      else
        fail(ArgumentError, 'Invalid headless option')
      end
    end

    browser = Playwright.create(playwright_cli_executable_path: PLAYWRIGHT_CLI_EXECUTABLE_PATH)
                        .playwright
                        .chromium
                        .launch(headless:)

    browser.new_page(baseURL: Capybara.current_session.server.base_url, javaScriptEnabled: javascript_enabled).tap do |page|
      page.set_default_timeout(DEFAULT_TIMEOUT)
    end
  end
  # rubocop:enable Rails/SaveBang

  def self.close_browsers
    RSpec.configuration.playwright_page_with_js_enabled&.context&.browser&.close
    RSpec.configuration.playwright_page_with_js_disabled&.context&.browser&.close
    RSpec.configuration.playwright_page_with_js_enabled = nil
    RSpec.configuration.playwright_page_with_js_disabled = nil
  end
end
