require_relative 'rspec_playwright'

RSpec.configure do |config|
  config.add_setting :playwright_page

  # Start Playwright browser
  config.before(js: true) do
    config.playwright_page ||= RSpecPlaywright.start_browser
  end

  # # Use back default Capybara driver/browser
  # config.after(js: true) do
  #   Capybara.use_default_driver
  # end

  # Close Playwright browser
  config.after(:suite) do
    RSpecPlaywright.close_browser
  end
end
