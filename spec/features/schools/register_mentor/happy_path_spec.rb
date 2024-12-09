RSpec.describe 'Registering a mentor' do
  include_context 'fake trs api client'

  let(:page) { RSpec.configuration.playwright_page }
  let(:trn) { '9876543' }

  scenario 'happy path' do
    given_there_is_a_school_in_the_service
    and_there_is_an_ect_with_no_mentor_registered_at_the_school
    and_i_sign_in_as_that_school_user
    and_i_am_on_the_schools_landing_page
    when_i_click_to_assign_a_mentor_to_the_ect
    then_i_am_in_the_requirements_page

    when_i_click_continue
    then_i_should_be_taken_to_the_find_mentor_page

    when_i_submit_the_find_mentor_form(trn:, dob_day: '1', dob_month: '12', dob_year: '2000')
    then_i_should_be_taken_to_the_review_mentor_details_page
    and_i_should_see_the_mentor_details_in_the_review_page

    when_i_click_confirm_and_continue
    then_i_should_be_taken_to_the_email_address_page

    when_i_enter_the_mentor_email_address
    and_i_click_continue
    then_i_should_be_taken_to_the_check_answers_page
    and_i_should_see_all_the_mentor_data_on_the_page

    when_i_click_confirm_details
    then_i_should_be_taken_to_the_confirmation_page

    when_i_click_on_back_to_ects
    then_i_should_be_taken_to_the_ects_page
    and_the_ect_is_shown_linked_to_the_mentor_just_registered
  end

  def given_there_is_a_school_in_the_service
    @school = FactoryBot.create(:school, urn: "1234567")
  end

  def and_i_sign_in_as_that_school_user
    @user = sign_in_as_school_user(@school.urn)
  end

  def and_there_is_an_ect_with_no_mentor_registered_at_the_school
    @ect = FactoryBot.create(:ect_at_school_period, :active, school: @school)
    @ect_name = Teachers::Name.new(@ect.teacher).full_name
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
    expect(page.url).to end_with("/school/register-mentor/what-you-will-need?ect_id=#{Rack::Utils.escape(@ect.id)}")
  end

  def when_i_click_continue
    page.get_by_role('link', name: 'Continue').click
  end

  def then_i_should_be_taken_to_the_find_mentor_page
    path = '/school/register-mentor/find-mentor'
    expect(page.url).to end_with(path)
  end

  def when_i_submit_the_find_mentor_form(trn:, dob_day:, dob_month:, dob_year:)
    page.get_by_label('trn').fill(trn)
    page.get_by_label('day').fill(dob_day)
    page.get_by_label('month').fill(dob_month)
    page.get_by_label('year').fill(dob_year)
    page.get_by_role('button', name: 'Continue').click
  end

  def then_i_should_be_taken_to_the_review_mentor_details_page
    expect(page.url).to end_with('/school/register-mentor/review-mentor-details')
  end

  def and_i_should_see_the_mentor_details_in_the_review_page
    expect(page.get_by_text(trn)).to be_visible
    expect(page.get_by_text("Kirk Van Houten")).to be_visible
    expect(page.get_by_text("1 December 2000")).to be_visible
  end

  def when_i_click_confirm_and_continue
    page.get_by_role('button', name: 'Confirm and continue').click
  end

  def then_i_should_be_taken_to_the_email_address_page
    expect(page.url).to end_with('/school/register-mentor/email-address')
  end

  def when_i_enter_the_mentor_email_address
    page.get_by_label('email').fill('example@example.com')
  end

  def and_i_click_continue
    page.get_by_role('button', name: "Continue").click
  end

  def then_i_should_be_taken_to_the_check_answers_page
    expect(page.url).to end_with('/school/register-mentor/check-answers')
  end

  def and_i_should_see_all_the_mentor_data_on_the_page
    expect(page.locator('dt', hasText: 'Teacher reference number (TRN)')).to be_visible
    expect(page.locator('dd', hasText: trn)).to be_visible
    expect(page.locator('dt', hasText: 'Name')).to be_visible
    expect(page.locator('dd', hasText: 'Kirk Van Houten')).to be_visible
    expect(page.locator('dt', hasText: 'Email address')).to be_visible
    expect(page.locator('dd', hasText: 'example@example.com')).to be_visible
  end

  def when_i_click_confirm_details
    page.get_by_role('button', name: 'Confirm details').click
  end

  def then_i_should_be_taken_to_the_confirmation_page
    expect(page.url).to end_with('/school/register-mentor/confirmation')
  end

  def when_i_click_on_back_to_ects
    page.get_by_role('link', name: 'Back to ECTs').click
  end

  def then_i_should_be_taken_to_the_ects_page
    expect(page.url).to end_with('/schools/home/ects')
  end

  def and_the_ect_is_shown_linked_to_the_mentor_just_registered
    expect(page.get_by_text("Kirk Van Houten")).to be_visible
    expect(page.get_by_text(@ect_name)).to be_visible
  end
end
