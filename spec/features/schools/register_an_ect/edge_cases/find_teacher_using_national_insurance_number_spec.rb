RSpec.describe 'Registering an ECT' do
  include_context 'fake trs api client returns 404 then 200'

  let(:page) { RSpec.configuration.playwright_page }

  before do
    sign_in_as_admin
  end

  scenario 'Finding a teacher using national insurance number' do
    given_there_is_a_school_in_the_service
    and_i_am_on_the_schools_landing_page
    when_i_start_adding_an_ect
    then_i_am_in_the_requirements_page

    when_i_click_continue
    then_i_am_on_the_find_ect_step_page

    when_i_submit_a_trn_and_a_date_of_birth_that_does_not_match
    then_i_should_be_taken_to_the_national_insurance_number_step

    when_i_enter_a_matching_national_insurance_number
    then_i_should_be_taken_to_the_review_details_step
  end

  def given_there_is_a_school_in_the_service
    FactoryBot.create(:school, urn: "1234567")
  end

  def and_i_am_on_the_schools_landing_page
    path = '/schools/home/ects'
    page.goto path
    expect(page.url).to end_with(path)
  end

  def when_i_start_adding_an_ect
    page.get_by_role('link', name: 'Add an ECT').click
  end

  def then_i_am_in_the_requirements_page
    expect(page.url).to end_with('/schools/register-ect/what-you-will-need')
  end

  def when_i_click_continue
    page.get_by_role('link', name: 'Continue').click
  end

  def then_i_am_on_the_find_ect_step_page
    expect(page.url).to end_with('/schools/register-ect/find-ect')
  end

  def when_i_submit_a_trn_and_a_date_of_birth_that_does_not_match
    page.fill('#find-ect-trn-field', '9876543')
    page.fill('#find_ect_date_of_birth_3i', "1")
    page.fill('#find_ect_date_of_birth_2i', "2")
    page.fill('#find_ect_date_of_birth_1i', "1980")
    page.get_by_role('button', name: 'Continue').click
  end

  def then_i_should_be_taken_to_the_national_insurance_number_step
    expect(page.url).to end_with('/schools/register-ect/national-insurance-number')
  end

  def when_i_enter_a_matching_national_insurance_number
    page.get_by_label("National Insurance Number").fill("OA647867D")
    page.get_by_role('button', name: 'Continue').click
  end

  def then_i_should_be_taken_to_the_review_details_step
    expect(page.url).to end_with('/schools/register-ect/review-ect-details')
  end
end
