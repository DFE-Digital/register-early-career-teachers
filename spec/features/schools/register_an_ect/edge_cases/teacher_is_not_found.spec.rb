RSpec.describe 'Registering an ECT' do
  include_context 'fake trs api client that finds nothing'

  let(:page) { RSpec.configuration.playwright_page }

  before do
    sign_in_as_admin
  end

  scenario 'Teacher is not found' do
    given_i_am_on_the_find_ect_step_page
    and_i_submit_a_trn_and_a_date_of_birth_that_does_not_match
    then_i_should_be_taken_to_the_national_insurance_number_step

    when_i_enter_a_national_insurance_number_that_does_not_match
    then_i_should_be_taken_to_the_teacher_not_found_error_page
  end

  def given_i_am_on_the_find_ect_step_page
    path = '/schools/register-ect/find-ect'
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
    path = '/schools/register-ect/national-insurance-number'
    page.goto path
    expect(page.url).to end_with(path)
  end

  def when_i_enter_a_national_insurance_number_that_does_not_match
    page.fill('#national-insurance-number-national-insurance-number-field', 'OA647867D
')
    page.click('text=Continue')
  end

  def then_i_should_be_taken_to_the_teacher_not_found_error_page
    path = '/schools/register-ect/not-found'
    expect(page.url).to end_with(path)
  end
end
