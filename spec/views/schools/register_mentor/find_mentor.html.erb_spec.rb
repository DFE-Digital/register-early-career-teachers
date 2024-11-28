RSpec.describe "schools/register_mentor/find_mentor.html.erb" do
  let(:back_path) { schools_register_mentor_start_path }
  let(:continue_path) { schools_register_mentor_find_mentor_path }
  let(:step) { Schools::RegisterMentor::FindMentorStep.new }
  let(:title) { "Find a mentor" }
  let(:wizard) { Schools::RegisterMentor::Wizard.new(current_step: :find_mentor, store: {}) }

  it "sets the page title to 'Find a mentor'" do
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

  it 'includes a back button that links to the start page of the register mentor journey' do
    assign(:wizard, wizard)

    render

    expect(view.content_for(:backlink_or_breadcrumb)).to have_link('Back', href: back_path)
  end

  it 'includes a continue button that posts to the find mentor page' do
    assign(:wizard, wizard)

    render

    expect(rendered).to have_button('Continue')
    expect(rendered).to have_selector("form[action='#{continue_path}']")
  end
end
