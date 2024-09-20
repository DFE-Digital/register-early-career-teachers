# frozen_string_literal: true

module PageHelper
  def page
    RSpec.configuration.playwright_page
  end
end

RSpec.configure do |config|
  config.include PageHelper, type: :feature
end
