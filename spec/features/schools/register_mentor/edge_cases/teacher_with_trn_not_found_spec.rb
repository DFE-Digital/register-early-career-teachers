RSpec.describe 'Registering a mentor' do
  include_context 'fake trs api client that finds nothing'

  let(:page) { RSpec.configuration.playwright_page }

  before do
    sign_in_as_admin
  end

  scenario 'Teacher with TRN is not found' do
    given_there_is_a_school_in_the_service
    and_there_is_an_ect_with_no_mentor_registered_at_the_school
    and_i_am_on_the_schools_landing_page
    when_i_click_to_assign_a_mentor_to_the_ect
    then_i_am_in_the_requirements_page

    when_i_click_continue
    then_i_should_be_taken_to_the_find_mentor_page

    and_i_submit_a_date_of_birth_and_unknown_trn
    then_i_should_be_taken_to_the_teacher_not_found_error_page

    when_i_click_try_again
    then_i_should_be_taken_to_the_find_mentor_step_page
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

  def when_i_submit_a_date_of_birth_and_unknown_trn
    page.get_by_label('trn').fill('9876543')
    page.get_by_label('day').fill('1')
    page.get_by_label('month').fill('2')
    page.get_by_label('year').fill('1980')
    page.get_by_role('button', name: 'Continue').click
  end

  def then_i_should_be_taken_to_the_teacher_not_found_error_page
    path = '/school/register-mentort/trn-not-found'
    expect(page.url).to end_with(path)
  end

  def given_i_am_on_the_find_mentor_step_page
    path = '/school/register-mentor/find-mentor'
    page.goto path
    expect(page.url).to end_with(path)
  end

  def and_i_submit_a_date_of_birth_and_unknown_trn
    page.get_by_label('trn').fill('9876543')
    page.get_by_label('day').fill('1')
    page.get_by_label('month').fill('2')
    page.get_by_label('year').fill('1980')
    page.get_by_role('button', name: 'Continue').click
  end

  def then_i_should_be_taken_to_the_teacher_not_found_error_page
    path = '/school/register-mentor/trn-not-found'
    expect(page.url).to end_with(path)
  end

  def when_i_click_try_again
    page.get_by_role('link', name: 'Try again').click
  end

  def then_i_should_be_taken_to_the_find_mentor_step_page
    path = '/school/register-mentor/find-mentor'
    expect(page.url).to end_with(path)
  end
end