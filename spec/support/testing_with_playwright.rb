require_relative 'rspec_playwright'

RSpec.configure do |config|
  config.add_setting :playwright_page
  config.add_setting :playwright_page_with_js_enabled
  config.add_setting :playwright_page_with_js_disabled

  # Start/Reuse Playwright browser
  config.before(type: :feature) do
    if Capybara.current_driver == :js_enabled
      config.playwright_page_with_js_enabled ||= RSpecPlaywright.start_browser(js: true)
      config.playwright_page = config.playwright_page_with_js_enabled
    else
      config.playwright_page_with_js_disabled ||= RSpecPlaywright.start_browser(js: false)
      config.playwright_page = config.playwright_page_with_js_disabled
    end
  end

  # Close Playwright browsers
  config.after(:suite) do
    RSpecPlaywright.close_browsers
  end
end
