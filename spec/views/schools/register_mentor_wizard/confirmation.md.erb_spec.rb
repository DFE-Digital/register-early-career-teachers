RSpec.describe "schools/register_mentor_wizard/confirmation.md.erb" do
  let(:your_ects_path) { schools_ects_home_path }
  let(:mentor) { wizard.mentor }
  let(:title) { "You've assigned #{mentor.full_name} as a mentor" }
  let(:store) { double(trs_first_name: "John", trs_last_name: "Wayne", for_ect_named: "Michael Dixon") }
  let(:wizard) { Schools::RegisterMentorWizard::Wizard.new(current_step: :confirmation, store:) }

  before do
    assign(:wizard, wizard)
    assign(:mentor, mentor)
  end

  it "sets the page title to 'You've assigned Samuel Taylor as a mentor'" do
    render

    expect(sanitize(view.content_for(:page_title))).to eql(sanitize(title))
  end

  it 'includes no back button' do
    render

    expect(view.content_for(:backlink_or_breadcrumb)).to be_blank
  end

  it 'includes a button that links to the school home page' do
    render

    expect(rendered).to have_link('Back to ECTs', href: your_ects_path)
  end
end
