RSpec.describe "schools/register_ect/national_insurance_number.html.erb" do
  let(:back_path) { schools_register_ect_find_ect_path }
  let(:continue_path) { schools_register_ect_national_insurance_number_path }
  let(:step) { Schools::RegisterECT::NationalInsuranceNumberStep.new }
  let(:title) { "We cannot find your ECT's details" }
  let(:wizard) { Schools::RegisterECT::Wizard.new(current_step: :national_insurance_number, store: {}) }

  it "sets the page title to 'We cannot find your ECT's details'" do
    assign(:wizard, wizard)

    render

    expect(sanitize(view.content_for(:page_title))).to eql(sanitize(title))
  end

  it "prefixes the page with 'Error:' when the trn or date of birth values are invalid" do
    assign(:wizard, wizard)

    wizard.valid_step?
    render

    expect(view.content_for(:page_title)).to start_with('Error:')
  end

  it 'renders an error summary when the trn or date of birth is invalid' do
    assign(:wizard, wizard)

    wizard.valid_step?
    render

    expect(view.content_for(:error_summary)).to have_css('.govuk-error-summary')
  end

  it 'includes a back button that links to the start page of the register ECT journey' do
    assign(:wizard, wizard)

    render

    expect(view.content_for(:backlink_or_breadcrumb)).to have_link('Back', href: back_path)
  end

  it 'includes a continue button that submits the form' do
    assign(:wizard, wizard)

    render

    expect(rendered).to have_button('Continue')
    expect(rendered).to have_selector("form[action='#{continue_path}']")
  end
end
