RSpec.describe 'Registering an ECT' do
  include_context 'fake trs api returns a teacher and then a teacher that has completed their induction'

  let(:page) { RSpec.configuration.playwright_page }

  before do
    sign_in_as_admin
  end

  scenario 'User enters national insurance number but teacher has completed their induction' do
    given_i_am_on_the_find_ect_step_page

    and_i_submit_a_date_of_birth_that_does_not_match
    then_i_should_be_taken_to_the_national_insurance_number_step

    when_i_enter_a_matching_national_insurance_number_but_the_teacher_has_completed_their_induction
    then_i_should_be_taken_to_the_teacher_has_completed_their_induction_error_page

    when_i_click_register_another_ect
    then_i_should_be_taken_to_the_find_ect_step_page
  end

  def given_i_am_on_the_find_ect_step_page
    path = '/schools/register-ect/find-ect'
    page.goto path
    expect(page.url).to end_with(path)
  end

  def and_i_submit_a_date_of_birth_that_does_not_match
    page.get_by_label('trn').fill('9876543')
    page.get_by_label('day').fill('1')
    page.get_by_label('month').fill('2')
    page.get_by_label('year').fill('1980')
    page.get_by_role('button', name: 'Continue').click
  end

  def then_i_should_be_taken_to_the_teacher_has_completed_their_induction_error_page
    path = '/schools/register-ect/induction-completed'
    expect(page.url).to end_with(path)
  end

  def then_i_should_be_taken_to_the_national_insurance_number_step
    expect(page.url).to end_with('/schools/register-ect/national-insurance-number')
  end

  def when_i_enter_a_matching_national_insurance_number_but_the_teacher_has_completed_their_induction
    page.get_by_label("National Insurance Number").fill("OA647867D")
    page.get_by_role('button', name: 'Continue').click
  end

  def when_i_click_register_another_ect
    page.get_by_role('link', name: 'Register another ECT').click
  end

  def then_i_should_be_taken_to_the_find_ect_step_page
    path = '/schools/register-ect/find-ect'
    expect(page.url).to end_with(path)
  end
end
