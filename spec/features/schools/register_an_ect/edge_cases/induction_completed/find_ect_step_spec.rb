RSpec.describe 'Registering an ECT' do
  include_context 'fake trs api client that finds teacher that has passed their induction'

  let(:page) { RSpec.configuration.playwright_page }

  scenario 'User enters date of birth (find ECT step) but teacher has completed their induction' do
    given_i_am_logged_in_as_a_school_user
    when_i_am_on_the_find_ect_step_page
    and_i_submit_a_date_of_birth_and_trn_of_a_teacher_that_has_completed_their_induction
    then_i_should_be_taken_to_the_teacher_has_completed_their_induction_error_page

    when_i_click_register_another_ect
    then_i_should_be_taken_to_the_find_ect_step_page
  end

  def given_i_am_logged_in_as_a_school_user
    school = FactoryBot.create(:school)
    sign_in_as_school_user(school.urn)
  end

  def when_i_am_on_the_find_ect_step_page
    path = '/schools/register-ect/find-ect'
    page.goto path
    expect(page.url).to end_with(path)
  end

  def and_i_submit_a_date_of_birth_and_trn_of_a_teacher_that_has_completed_their_induction
    page.get_by_label('trn').fill('9876543')
    page.get_by_label('day').fill('1')
    page.get_by_label('month').fill('12')
    page.get_by_label('year').fill('2000')
    page.get_by_role('button', name: 'Continue').click
  end

  def then_i_should_be_taken_to_the_teacher_has_completed_their_induction_error_page
    path = '/schools/register-ect/induction-completed'
    expect(page.url).to end_with(path)
  end

  def when_i_click_register_another_ect
    page.get_by_role('link', name: 'Register another ECT').click
  end

  def then_i_should_be_taken_to_the_find_ect_step_page
    path = '/schools/register-ect/find-ect'
    expect(page.url).to end_with(path)
  end
end
