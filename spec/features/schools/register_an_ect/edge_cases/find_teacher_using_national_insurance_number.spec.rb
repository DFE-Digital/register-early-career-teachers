RSpec.describe 'Registering an ECT' do
  include_context 'fake trs api client returns 404 then 200'

  let(:page) { RSpec.configuration.playwright_page }

  before do
    sign_in_as_admin
  end

  scenario 'Finding a teacher using national insurance number' do
    given_i_am_on_the_find_ect_step_page
    and_i_submit_a_trn_and_a_date_of_birth_that_does_not_match
    then_i_should_be_taken_to_the_national_insurance_number_step

    when_i_enter_a_matching_national_insurance_number
    then_i_should_be_taken_to_the_review_details_step
  end

  def given_i_am_on_the_find_ect_step_page
    path = '/schools/find-ect'
    page.goto path
    expect(page.url).to end_with(path)
  end

  def and_i_submit_a_trn_and_a_date_of_birth_that_does_not_match
    page.fill('#find-ect-trn-field', '9876543')
    page.fill('#find_ect_date_of_birth_3i', "1")
    page.fill('#find_ect_date_of_birth_2i', "2")
    page.fill('#find_ect_date_of_birth_1i', "1980")
    page.click('text=Continue')
  end

  def then_i_should_be_taken_to_the_national_insurance_number_step
    path = '/schools/national-insurance-number'
    page.goto path
    expect(page.url).to end_with(path)
  end

  def when_i_enter_a_matching_national_insurance_number
    page.fill('#national-insurance-number-national-insurance-number-field', 'OA647867D')
    page.click('text=Continue')
  end

  def then_i_should_be_taken_to_the_review_details_step
    path = '/schools/review-ect-details'
    expect(page.url).to end_with(path)
  end
end
