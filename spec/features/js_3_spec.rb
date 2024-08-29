describe 'city form' do
  5.times do
    it 'navigates to the city entered' do
      visit("/cities")

      fill_in("name", with: "London")
      click_button("Go to City")

      expect(page).to have_content 'Welcome to London'
      expect(page).to have_current_path '/cities/london'
    end
  end
end
