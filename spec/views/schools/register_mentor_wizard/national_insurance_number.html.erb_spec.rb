RSpec.describe "schools/register_mentor_wizard/national_insurance_number.html.erb" do
  let(:back_path) { schools_register_mentor_wizard_find_mentor_path }
  let(:continue_path) { schools_register_mentor_wizard_national_insurance_number_path }
  let(:title) { "We cannot find the mentor's details" }
  let(:wizard) { Schools::RegisterMentorWizard::Wizard.new(current_step: :national_insurance_number, store: {}) }

  before do
    assign(:wizard, wizard)
  end

  it "sets the page title to 'We cannot find the mentor's details'" do
    render

    expect(sanitize(view.content_for(:page_title))).to eql(sanitize(title))
  end

  it "prefixes the page with 'Error:' when the national insurance number is invalid" do
    wizard.valid_step?
    render

    expect(view.content_for(:page_title)).to start_with('Error:')
  end

  it 'renders an error summary when the national insurance number is invalid' do
    wizard.valid_step?
    render

    expect(view.content_for(:error_summary)).to have_css('.govuk-error-summary')
  end

  it 'includes a back button that links to trn and dob page of the journey' do
    render

    expect(view.content_for(:backlink_or_breadcrumb)).to have_link('Back', href: back_path)
  end

  it 'includes a continue button that posts to the national insurance number page' do
    render

    expect(rendered).to have_button('Continue')
    expect(rendered).to have_selector("form[action='#{continue_path}']")
  end
end
