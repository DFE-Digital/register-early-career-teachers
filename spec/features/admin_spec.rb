require "rails_helper"

RSpec.describe "Admin", type: :feature do
  # TODO: This test should be replaced with something meaningful.
  # Just here to prove Capybara is working.
  scenario "visiting the admin placeholder page" do
    given_i_am_logged_in_as_an_admin
    when_i_visit_the_admin_placeholder_page
    then_i_should_see_the_admin_placeholder_page
  end

  def given_i_am_logged_in_as_an_admin
    session_manager = instance_double(Sessions::SessionManager, provider: "developer", expires_at: 2.hours.from_now)
    admin = FactoryBot.create(:user)
    allow(Sessions::SessionManager).to receive(:new).and_return(session_manager)
    allow(session_manager).to receive(:load_from_session).and_return(admin)
  end

  def when_i_visit_the_admin_placeholder_page
    visit admin_path
  end

  def then_i_should_see_the_admin_placeholder_page
    expect(page).to have_content("Placeholder page for the admin site")
  end
end
