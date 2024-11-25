RSpec.describe 'Registering an ECT' do
  include_context 'fake trs api client that finds nothing'

  let(:page) { RSpec.configuration.playwright_page }

  before do
    sign_in_as_admin
  end

  scenario 'Teacher with TRN is not found' do
    given_i_am_on_the_find_ect_step_page
    and_i_submit_a_date_of_birth_and_unknown_trn
    then_i_should_be_taken_to_the_teacher_not_found_error_page
  end

  def given_i_am_on_the_find_ect_step_page
    path = '/schools/register-ect/find-ect'
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
    path = '/schools/register-ect/trn-not-found'
    expect(page.url).to end_with(path)
  end
end
