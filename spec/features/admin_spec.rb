require "rails_helper"

RSpec.describe "Admin" do
  # TODO: This test should be replaced with something meaningful.
  # Just here to prove Playwright is working.
  scenario "visiting the admin placeholder page" do
    given_i_am_logged_in_as_an_admin
    when_i_visit_the_admin_placeholder_page
    then_i_should_see_the_admin_placeholder_page
  end

  def given_i_am_logged_in_as_an_admin
    sign_in_as_admin
  end

  def when_i_visit_the_admin_placeholder_page
    page.goto(admin_path)
  end

  def then_i_should_see_the_admin_placeholder_page
    expect(page.get_by_text("Placeholder page for the admin site")).to be_visible
  end
end
