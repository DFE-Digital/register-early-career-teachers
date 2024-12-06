RSpec.describe "schools/register_mentor_wizard/start.html.erb" do
  let(:back_path) { schools_ects_home_path }
  let(:continue_path) { schools_register_mentor_wizard_find_mentor_path }
  let(:ect_name) { 'James Lorie' }
  let(:title) { "What you'll need to add a new mentor for #{ect_name}" }

  before do
    assign(:ect_name, ect_name)
  end

  it "sets the page title to 'What you'll need to add a new mentor for <ect_name>'" do
    render

    expect(sanitize(view.content_for(:page_title))).to eql(sanitize(title))
  end

  it 'includes a back button that links to the school home page' do
    render

    expect(view.content_for(:backlink_or_breadcrumb)).to have_link('Back', href: back_path)
  end

  it 'includes a continue button that links to the find mentor page' do
    render

    expect(rendered).to have_link('Continue', href: continue_path)
  end
end
