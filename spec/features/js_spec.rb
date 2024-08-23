require 'rails_helper'

def select_from_accessible_autocomplete(page:, selector:, text:, down_key_presses: 0)
  input = page.find(selector)
  input.send_keys(text)
  options = page.find("#{selector}__listbox")
  down_key_presses.times { options.native.press("ArrowDown") }
  options.native.press("Enter")
end

describe 'autocomplete' do
  it %(selects 'The United Kingdom'), js: true do
    visit '/countries/new'

    select_from_accessible_autocomplete(page:,
                                        selector: ('#my-autocomplete'),
                                        text: "United",
                                        down_key_presses: 2)

    click_button 'Continue'

    expect(File.read('tmp/selection')).to include("United Kingdom")
  end
end
