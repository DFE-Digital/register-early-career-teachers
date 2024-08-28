require_relative 'rspec_playwright'

RSpec.configure do |config|
  config.add_setting :playwright_page

  # Start Playwright browser
  config.before(playwright: true) do
    # Don't use default Capybara driver/browser
    Capybara.current_driver = :null
    config.playwright_page ||= RSpecPlaywright.start_browser
  end

  # Use back default Capybara driver/browser
  config.after(playwright: true) do
    Capybara.use_default_driver
  end

  # Close Playwright browser
  config.after(:suite) do
    RSpecPlaywright.close_browser
  end
end
