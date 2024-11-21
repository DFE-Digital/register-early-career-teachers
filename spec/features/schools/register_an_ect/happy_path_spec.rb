RSpec.describe 'Registering an ECT' do
  include_context 'fake trs api client'

  let(:page) { RSpec.configuration.playwright_page }
  let(:trn) { '9876543' }

  before do
    sign_in_as_admin
  end

  scenario 'happy path' do
    # Temporary: We need to have a school in the db so that when the user
    # returned to /schools/ects/home we can attempt to fetch and display ects / mentors from the db
    given_there_is_a_school
    and_i_am_on_the_start_page
    when_i_click_continue
    i_should_be_taken_to_the_find_ect_page

    when_i_fill_in_the_find_ect_form(trn:, dob_day: '1', dob_month: '12', dob_year: '2000')
    and_i_click_continue
    then_i_should_be_taken_to_the_review_ect_details_page
    and_i_should_see_the_ect_details_in_the_review_page

    when_i_click_confirm_and_continue
    then_i_should_be_taken_to_the_email_address_page
    when_i_enter_the_ect_email_address
    and_i_click_continue
    then_i_should_be_taken_to_the_check_answers_page
    and_i_should_see_all_the_ect_data_on_the_page

    when_i_click_confirm_details
    then_i_should_be_taken_to_the_confirmation_page

    when_i_click_on_back_to_your_ects
    then_i_should_be_taken_to_the_ects_page
  end

  def given_there_is_a_school
    FactoryBot.create(:school, urn: "1234567")
  end

  def and_i_am_on_the_start_page
    path = '/schools/register-ect/what-you-will-need'
    page.goto path
    expect(page.url).to end_with(path)
  end

  def i_should_be_taken_to_the_find_ect_page
    path = '/schools/register-ect/find-ect'
    expect(page.url).to end_with(path)
  end

  def when_i_fill_in_the_find_ect_form(trn:, dob_day:, dob_month:, dob_year:)
    page.fill('#find-ect-trn-field', trn)
    page.fill('#find_ect_date_of_birth_3i', dob_day)
    page.fill('#find_ect_date_of_birth_2i', dob_month)
    page.fill('#find_ect_date_of_birth_1i', dob_year)
  end

  def when_i_click_continue
    continue_click
  end

  def and_i_click_continue
    continue_click
  end

  def when_i_click_confirm_details
    page.click("text=Confirm details")
  end

  def when_i_click_confirm_and_continue
    page.click("text=Confirm and continue")
  end

  def then_i_should_be_taken_to_the_review_ect_details_page
    path = '/schools/register-ect/review-ect-details'
    expect(page.url).to end_with(path)
  end

  def and_i_should_see_the_ect_details_in_the_review_page
    expect(page.get_by_text(trn)).to be_visible
    expect(page.get_by_text("Kirk Van Houten")).to be_visible
    expect(page.get_by_text("1 December 2000")).to be_visible
  end

  def then_i_should_be_taken_to_the_email_address_page
    path = '/schools/register-ect/email-address'
    expect(page.url).to end_with(path)
  end

  def when_i_enter_the_ect_email_address
    page.fill('#email-address-email-field', 'example@example.com')
  end

  def then_i_should_be_taken_to_the_check_answers_page
    path = '/schools/register-ect/check-answers'
    expect(page.url).to end_with(path)
  end

  def and_i_should_see_all_the_ect_data_on_the_page
    expect(page.get_by_text(trn)).to be_visible
    expect(page.get_by_text("Kirk Van Houten")).to be_visible
    expect(page.get_by_text("1 December 2000")).to be_visible
    expect(page.get_by_text('example@example.com')).to be_visible
  end

  def then_i_should_be_taken_to_the_confirmation_page
    path = '/schools/register-ect/confirmation'
    expect(page.url).to end_with(path)
  end

  def when_i_click_on_back_to_your_ects
    page.click("text=Back to your ECTs")
  end

  def then_i_should_be_taken_to_the_ects_page
    path = '/schools/home/ects'
    expect(page.url).to end_with(path)
  end

  def continue_click
    page.click('text=Continue')
  end
end
