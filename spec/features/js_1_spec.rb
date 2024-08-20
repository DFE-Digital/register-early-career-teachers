describe 'autocomplete' do
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
    end
  end
end
