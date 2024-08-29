describe 'autocomplete 1 JS', :js do
  let(:page) { RSpec.configuration.playwright_page }

  it 'can use Playwright to test a page with JavaScript enabled' do
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

describe 'autocomplete 2' do
  it 'can use rack-test to test a page with JavaScript disabled' do
    visit("/countries")

    expect(page).to have_selector("label", text: "Select your country", visible: true)
    expect(page).not_to have_selector("input", text: "#my-autocomplete")
    expect(page).to have_element(type: 'submit', value: 'Go to country')
  end
end

describe 'autocomplete 3 JS', :js do
  let(:page) { RSpec.configuration.playwright_page }

  it 'can switch back to Playwright to test a page with JavaScript enabled' do
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

describe 'city form' do
  it 'can switch back to rack-test to test a page with JavaScript disabled' do
    visit("/cities")

    fill_in("name", with: "London")
    click_button("Go to City")

    expect(page).to have_content 'Welcome to London'
    expect(page).to have_current_path '/cities/london'
  end
end
