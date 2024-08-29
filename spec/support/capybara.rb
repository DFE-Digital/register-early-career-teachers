require 'capybara/rspec'

class CapybaraNullDriver < Capybara::Driver::Base
  def needs_server?
    true
  end
end

Capybara.server = :puma, { Silent: true }
Capybara.register_driver(:null) { CapybaraNullDriver.new }
Capybara.default_max_wait_time = 5
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :null
Capybara.save_path = 'tmp/capybara'
