RSpec.describe 'Registering an ECT' do
  include_context 'fake trs api client'

  let(:page) { RSpec.configuration.playwright_page }
  let(:trn) { '9876543' }
  let(:trs_teacher_stub) do
    {
      'firstName' => 'Kate',
      'lastName' => 'Smith',
      'trn' => trn,
      'dateOfBirth' => '2000-12-01',
    }
  end
  let(:trs_client) { instance_double(TRS::APIClient) }

  before do
    sign_in_as_admin
  end

  scenario 'Happy path' do
    given_i_am_on_the_start_page
    when_i_click_on_the_continue_link
    i_should_be_taken_to_the_find_ect_page

    when_i_fill_in_the_find_ect_form(trn:, dob_day: '1', dob_month: '12', dob_year: '2000')
    and_i_click_on_the_continue_button
    then_i_should_be_taken_to_the_review_ect_details_page
    and_i_should_see_the_ect_details_in_the_review_page
  end

  def given_i_am_on_the_start_page
    path = '/schools/what-you-will-need'
    page.goto path
    expect(page.url).to end_with(path)
  end

  def when_i_click_on_the_continue_link
    page.click('text=Continue')
  end

  def i_should_be_taken_to_the_find_ect_page
    path = '/schools/find-ect'
    expect(page.url).to end_with(path)
  end

  def when_i_fill_in_the_find_ect_form(trn:, dob_day:, dob_month:, dob_year:)
    page.fill('#find-ect-trn-field', trn)

    page.fill('#find_ect_date_of_birth_3i', dob_day)
    page.fill('#find_ect_date_of_birth_2i', dob_month)
    page.fill('#find_ect_date_of_birth_1i', dob_year)
  end

  def and_i_click_on_the_continue_button
    page.click('text=Continue')
  end

  def then_i_should_be_taken_to_the_review_ect_details_page
    path = '/schools/review-ect-details'
    expect(page.url).to end_with(path)
  end

  def and_i_should_see_the_ect_details_in_the_review_page
    expect(page.get_by_text(trn)).to be_visible
    expect(page.get_by_text("Kirk Van Houten")).to be_visible
    expect(page.get_by_text("1 December 2000")).to be_visible
  end
end
