require_relative 'rspec_playwright'

RSpec.configure do |config|
  config.add_setting :playwright_page
  config.add_setting :playwright_page_with_js_enabled
  config.add_setting :playwright_page_with_js_disabled
  config.add_setting :rails_server_pid

  # Start/Reuse JS-disabled Playwright browser and Rails app
  config.before(type: :feature) do
    config.rails_server_pid ||= RSpecPlaywright.start_rails_app
    config.playwright_page_with_js_disabled ||= RSpecPlaywright.start_browser(javascript_enabled: false)
    config.playwright_page = config.playwright_page_with_js_disabled
  end

  # Start/Reuse JS-enabled Playwright browser
  config.before(type: :feature, js: true) do
    config.playwright_page_with_js_enabled ||= RSpecPlaywright.start_browser(javascript_enabled: true)
    config.playwright_page = config.playwright_page_with_js_enabled
  end

  # Close Playwright browsers and stop Rails app
  config.after(:suite) do
    RSpecPlaywright.close_browsers
    RSpecPlaywright.stop_rails_app
  end
end
