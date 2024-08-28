describe 'autocomplete', :playwright do
  let(:page) { RSpec.configuration.playwright_page }

  5.times do
    it 'can list and select options based on first characters typed' do
      page.goto("/countries")

      # Expect list of options to be hidden
      expect(page.locator('#my-autocomplete__listbox')).not_to be_visible

      # Type first chars into the autocomplete field
      autocomplete = page.wait_for_selector('input#my-autocomplete')
      autocomplete.type('un')

      # Expect list of options to be visible
      expect(page.locator('#my-autocomplete__listbox')).to be_visible

      7.times { page.keyboard.press('ArrowDown') }
      page.keyboard.press('Enter')

      expect(autocomplete.input_value).to eq("United Kingdom")

      page.get_by_role("button", name: 'Go to country').click
      expect(page.get_by_text("Welcome to United Kingdom")).to be_visible
      expect(page.url).to eq("#{Capybara.current_session.server.base_url}/countries/united-kingdom")
    end
  end
end
