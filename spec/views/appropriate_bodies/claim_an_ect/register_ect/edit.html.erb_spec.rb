RSpec.describe "appropriate_bodies/claim_an_ect/register_ect/edit.html.erb" do
  let(:pending_induction_submission) { FactoryBot.create(:pending_induction_submission, trs_first_name: 'Benjamin', trs_last_name: 'Whiterow') }

  it "sets the page title to 'Tell us about <name>'" do
    assign(:pending_induction_submission, pending_induction_submission)

    render

    expected_title = "Tell us about Benjamin Whiterow's induction"
    expect(sanitize(view.content_for(:page_title))).to eql(sanitize(expected_title))
  end

  it 'includes a back button that links to the AB homepage' do
    assign(:pending_induction_submission, pending_induction_submission)

    render

    expect(view.content_for(:backlink_or_breadcrumb)).to have_link('Back', href: "/appropriate-body/claim-an-ect/check-ect/#{pending_induction_submission.id}/edit")
  end

  it "prefixes the page with 'Error:' when the pending induction submission isn't valid" do
    pending_induction_submission.errors.add(:base, "An error")

    assign(:pending_induction_submission, pending_induction_submission)

    render

    expect(view.content_for(:page_title)).to start_with('Error:')
  end

  it 'renders an error summary when the pending induction submission is invalid' do
    pending_induction_submission.errors.add(:base, "An error")

    assign(:pending_induction_submission, pending_induction_submission)

    render

    expect(view.content_for(:error_summary)).to have_css('.govuk-error-summary')
  end
end
