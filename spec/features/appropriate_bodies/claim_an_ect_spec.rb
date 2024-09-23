require 'rails_helper'

RSpec.describe 'Claiming an ECT' do
  include_context 'fake_trs_api_client'

  let(:page) { RSpec.configuration.playwright_page }

  before { sign_in_as_appropriate_body_user }

  scenario 'Happy path' do
    given_i_am_on_the_claim_an_ect_find_page
    if_i_submit_with_errors_the_errors_are_reported_to_me(expected_errors: 2)
    when_i_enter_a_trn_and_date_of_birth_that_exist_in_trs
    and_i_submit_the_form

    now_i_should_be_on_the_claim_an_ect_check_page
    if_i_submit_with_errors_the_errors_are_reported_to_me(expected_errors: 1)
    when_i_confirm_the_details_are_correct
    and_i_submit_the_form

    now_i_should_be_on_the_claim_an_ect_register_page
    if_i_submit_with_errors_the_errors_are_reported_to_me(expected_errors: 2)
    when_i_enter_the_start_date
    and_choose_an_induction_programme
    and_i_submit_the_form

    then_i_should_be_on_the_confirmation_page
    and_the_data_i_submitted_should_be_saved_on_the_pending_record
  end

private

  def given_i_am_on_the_claim_an_ect_find_page
    path = '/appropriate-body/claim-an-ect/find-ect/new'
    page.goto(path)
    expect(page.url).to end_with(path)
  end

  def when_i_enter_a_trn_and_date_of_birth_that_exist_in_trs
    page.get_by_label('Teacher reference number').fill('1234567')
    page.get_by_label('Day').fill('1')
    page.get_by_label('Month').fill('2')
    page.get_by_label('Year').fill('2003')
  end

  def when_i_submit_the_form
    page.get_by_role('button', name: "Continue").click
  end
  alias_method :and_i_submit_the_form, :when_i_submit_the_form

  def now_i_should_be_on_the_claim_an_ect_check_page
    @pending_induction_submission = PendingInductionSubmission.last
    path = "/appropriate-body/claim-an-ect/check-ect/#{@pending_induction_submission.id}/edit"
    expect(page.url).to end_with(path)
  end

  def when_i_confirm_the_details_are_correct
    page.get_by_label('I have checked the information above and it looks accurate').check
  end

  def now_i_should_be_on_the_claim_an_ect_register_page
    path = "/appropriate-body/claim-an-ect/register-ect/#{@pending_induction_submission.id}/edit"
    expect(page.url).to end_with(path)
  end

  def when_i_enter_the_start_date
    page.get_by_label('Day').fill('3')
    page.get_by_label('Month').fill('4')
    @start_year = Time.zone.today.year - 2
    page.get_by_label('Year').fill(@start_year.to_s)
  end

  def and_choose_an_induction_programme
    page.get_by_label("Full induction programme").check
  end

  def then_i_should_be_on_the_confirmation_page
    path = "/appropriate-body/claim-an-ect/register-ect/#{@pending_induction_submission.id}"
    expect(page.url).to end_with(path)
  end

  def and_the_data_i_submitted_should_be_saved_on_the_pending_record
    @pending_induction_submission.reload.tap do |sub|
      expect(sub.date_of_birth).to eql(Date.new(2003, 2, 1))
      expect(sub.trs_first_name).to eql('Kirk')
      expect(sub.trs_last_name).to eql('Van Houten')
      expect(sub.started_on).to eql(Date.new(@start_year, 4, 3))
    end
  end

  def if_i_submit_with_errors_the_errors_are_reported_to_me(expected_errors: nil)
    when_i_submit_the_form

    expect(page.title).to start_with('Error:')

    error_summary = page.locator('.govuk-error-summary')

    expect(error_summary).to be_present
    expect(error_summary.locator('li').count).to eql(expected_errors)
  end
end
