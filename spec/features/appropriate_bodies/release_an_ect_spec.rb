RSpec.describe 'Releasing an ECT' do
  let(:page) { RSpec.configuration.playwright_page }
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:trn) { teacher.trn }
  let(:today) { Time.zone.today }
  let(:number_of_completed_terms) { 4 }

  before do
    sign_in_as_appropriate_body_user
  end

  let!(:induction_period) { FactoryBot.create(:induction_period, :active, teacher:, appropriate_body: @appropriate_body) }

  scenario 'Happy path' do
    given_i_am_on_the_ect_page(trn)
    when_i_click_link('Release ECT')
    then_i_should_be_on_the_release_ect_page(trn)

    when_i_submit_the_form_without_filling_anything_in
    then_i_should_see_an_error_summary
    and_the_page_title_should_start_with_error

    when_i_enter_the_finish_date
    and_i_enter_a_terms_value_of(number_of_completed_terms)
    and_i_click_continue

    then_i_should_be_on_the_success_page
    and_the_release_ect_service_should_have_been_called
    and_the_pending_induction_submission_should_have_been_deleted
  end

private

  def given_i_am_on_the_ect_page(trn)
    path = "/appropriate-body/teachers/#{trn}"
    page.goto(path)
    expect(page.url).to end_with(path)
  end

  def when_i_click_link(text)
    page.get_by_role('link', name: text).click
  end

  def then_i_should_be_on_the_release_ect_page(trn)
    expect(page.url).to end_with("/appropriate-body/teachers/#{trn}/release/new")
  end

  def when_i_submit_the_form_without_filling_anything_in
    and_i_click_continue
  end

  def then_i_should_see_an_error_summary
    expect(page.locator('.govuk-error-summary')).to be_present
  end

  def and_the_page_title_should_start_with_error
    expect(page.title).to start_with('Error:')
  end

  def when_i_enter_the_finish_date
    page.get_by_label('Day').fill(today.day.to_s)
    page.get_by_label('Month').fill(today.month.to_s)
    page.get_by_label('Year').fill(today.year.to_s)
  end

  def and_i_enter_a_terms_value_of(number)
    label = /How many terms/

    page.get_by_label(label).fill(number.to_s)
  end

  def and_i_click_continue
    page.get_by_role('button', name: 'Continue').click
  end

  def then_i_should_be_on_the_success_page
    expect(page.url).to end_with("/appropriate-body/teachers/#{trn}/release")
    expect(page.locator('.govuk-panel')).to be_present
  end

  def and_the_pending_induction_submission_should_have_been_deleted
    expect(PendingInductionSubmission.find_by(trn:, appropriate_body: @appropriate_body)).to be_nil
  end

  def and_the_release_ect_service_should_have_been_called
    induction_period.reload
    expect(induction_period.number_of_terms).to eql(number_of_completed_terms)
    expect(induction_period.finished_on).to eql(today)
  end
end
