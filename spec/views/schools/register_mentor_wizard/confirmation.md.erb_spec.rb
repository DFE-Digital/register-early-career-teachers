RSpec.describe "schools/register_mentor_wizard/confirmation.md.erb" do
  let(:ect_name) { "Michale Dixon" }
  let(:your_ects_path) { schools_ects_home_path }
  let(:mentor) { wizard.mentor }
  let(:title) { "You've assigned #{mentor.full_name} as a mentor" }
  let(:store) { double(trs_first_name: "John", trs_last_name: "Wayne") }
  let(:wizard) { Schools::RegisterMentorWizard::Wizard.new(current_step: :confirmation, store:) }

  before do
    assign(:wizard, wizard)
    assign(:ect_name, ect_name)
    assign(:mentor, mentor)
  end

  it "sets the page title to 'You've assigned <mentor name> as a mentor'" do
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
