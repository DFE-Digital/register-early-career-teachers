require_relative 'rspec_playwright'

RSpec.configure do |config|
  config.add_setting :rails_server_pid
  config.add_setting :playwright_page

  # Start Rails server and Playwright browser
  config.before(type: :feature) do
    config.rails_server_pid ||= RSpecPlaywright.start_rails_server
    config.playwright_page ||= RSpecPlaywright.start_browser
  end

  # Stop Rails server and close Playwright browser
  config.after(:suite) do
    RSpecPlaywright.stop_rails_server
    RSpecPlaywright.close_browser
  end
end
