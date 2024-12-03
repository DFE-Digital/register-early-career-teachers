RSpec.describe 'Registering a mentor' do
  let(:page) { RSpec.configuration.playwright_page }

  before do
    sign_in_as_admin
  end

  scenario 'Teacher without a TRN cannot be registered' do
    given_there_is_a_school_in_the_service
    and_there_is_an_ect_with_no_mentor_registered_at_the_school
    and_i_am_on_the_schools_landing_page
    when_i_click_to_assign_a_mentor_to_the_ect
    then_i_am_in_the_requirements_page

    when_i_click_continue
    then_i_should_be_taken_to_the_find_mentor_page

    when_i_click_they_do_not_have_a_trn
    then_i_should_be_taken_to_the_no_trn_page
  end

  def given_there_is_a_school_in_the_service
    @school = FactoryBot.create(:school, urn: "1234567")
  end

  def and_there_is_an_ect_with_no_mentor_registered_at_the_school
    @ect = FactoryBot.create(:ect_at_school_period, school: @school).teacher
    @ect_name = Teachers::Name.new(@ect).full_name
  end

  def and_i_am_on_the_schools_landing_page
    path = '/schools/home/ects'
    page.goto path
    expect(page.url).to end_with(path)
  end

  def when_i_click_to_assign_a_mentor_to_the_ect
    page.get_by_role('link', name: 'assign a mentor or register a new one').click
  end

  def then_i_am_in_the_requirements_page
    expect(page.get_by_text("What you'll need to add a new mentor for #{@ect_name}")).to be_visible
    expect(page.url).to end_with("/school/register-mentor/what-you-will-need?ect_name=#{Rack::Utils.escape(@ect_name)}")
  end

  def when_i_click_continue
    page.get_by_role('link', name: 'Continue').click
  end

  def then_i_should_be_taken_to_the_find_mentor_page
    path = '/school/register-mentor/find-mentor'
    expect(page.url).to end_with(path)
  end

  def when_i_click_they_do_not_have_a_trn
    page.get_by_role('link', name: 'They do not have a TRN').click
  end

  def then_i_should_be_taken_to_the_no_trn_page
    expect(page.url).to end_with('/school/register-mentor/no-trn')
  end
end
