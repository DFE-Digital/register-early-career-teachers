require 'net/http'
require 'uri'
require 'timeout'
require 'playwright'

module RSpecPlaywright
  PLAYWRIGHT_CLI_EXECUTABLE_PATH = "./node_modules/.bin/playwright".freeze
  RAILS_SERVER_PROTOCOL = "http".freeze
  RAILS_SERVER_HOST = "localhost".freeze
  RAILS_SERVER_PORT = rand(50_000..65_000)
  RAILS_SERVER_URL = "#{RAILS_SERVER_PROTOCOL}://#{RAILS_SERVER_HOST}:#{RAILS_SERVER_PORT}".freeze
  RAILS_SERVER_BOOT_COMMAND = "exec bin/rails server -e test -p #{RAILS_SERVER_PORT} > tmp/rails_playwright_last_run 2>&1".freeze
  RAILS_SERVER_BOOT_TIMEOUT_SECONDS = 10
  RAILS_SERVER_BOOT_TIMEOUT_MESSAGE = "Rails server boot timed out!".freeze

  # rubocop:disable Rails/SaveBang
  def self.start_browser(javascript_enabled: false)
    browser = Playwright.create(playwright_cli_executable_path: PLAYWRIGHT_CLI_EXECUTABLE_PATH)
                        .playwright
                        .chromium
                        .launch(headless: true)
    browser.new_page(baseURL: RAILS_SERVER_URL, javaScriptEnabled: javascript_enabled)
  end
  # rubocop:enable Rails/SaveBang

  def self.close_browsers
    RSpec.configuration.playwright_page_with_js_enabled&.context&.browser&.close
    RSpec.configuration.playwright_page_with_js_disabled&.context&.browser&.close
    RSpec.configuration.playwright_page_with_js_enabled = nil
    RSpec.configuration.playwright_page_with_js_disabled = nil
  end

  def self.start_rails_app
    spawn(RAILS_SERVER_BOOT_COMMAND).tap do |pid|
      Timeout.timeout(RAILS_SERVER_BOOT_TIMEOUT_SECONDS) do
        loop do
          Net::HTTP.get_response(URI.parse(RAILS_SERVER_URL))
          break
        rescue Errno::ECONNREFUSED
          sleep 1
        end
      end
    rescue Timeout::Error
      stop_rails_server(pid:)
      raise RAILS_SERVER_BOOT_TIMEOUT_MESSAGE
    end
  end

  def self.stop_rails_app(pid: RSpec.configuration.rails_server_pid)
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
    RSpec.configuration.rails_server_pid = nil
  end
end
