require 'capybara/rspec'

class CapybaraNullDriver < Capybara::Driver::Base
  def needs_server?
    true
  end
end

Capybara.server = :puma, { Silent: true }
Capybara.register_driver(:js_enabled) { CapybaraNullDriver.new }
Capybara.register_driver(:js_disabled) { CapybaraNullDriver.new }
Capybara.default_max_wait_time = 5
Capybara.default_driver = :js_disabled
Capybara.javascript_driver = :js_enabled
Capybara.save_path = 'tmp/capybara'
