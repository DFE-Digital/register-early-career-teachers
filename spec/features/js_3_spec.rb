describe 'city form' do
  let(:user) { FactoryBot.create(:user, email: "user@example.com", name: "Testing User") }

  before do
    sign_in_as(user)
  end

  5.times do
    it 'can test a page containing no JavaScript with a JS-disabled Playwright browser' do
      page.goto("/cities")
      page.get_by_label('Name').fill('London')
      page.get_by_role("button", name: "Go to city").click

      expect(page.get_by_text("Welcome to London")).to be_visible
      expect(page.url).to eq("#{Capybara.current_session.server.base_url}/cities/london")
    end
  end
end
