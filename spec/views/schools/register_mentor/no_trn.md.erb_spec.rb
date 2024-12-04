RSpec.describe "schools/register_mentor/no_trn.md.erb" do
  let(:find_a_lost_trn_path) { "https://find-a-lost-trn.education.gov.uk/start" }
  let(:request_a_trn_path) { "https://www.gov.uk/guidance/teacher-reference-number-trn#if-youre-a-mentor-for-a-trainee-or-early-career-teacher" }
  let(:school_home_path) { schools_ects_home_path }
  let(:title) { "You cannot register a mentor without a TRN" }

  before do
    render
  end

  it "sets the page title to 'You cannot register a mentor without a TRN'" do
    expect(sanitize(view.content_for(:page_title))).to eql(sanitize(title))
  end

  it 'includes no back button' do
    expect(view.content_for(:backlink_or_breadcrumb)).to be_blank
  end

  it 'includes a link to the Find a lost TRN service' do
    expect(rendered).to have_link('Find a lost TRN service', href: find_a_lost_trn_path)
  end

  it 'includes a link to request a TRN' do
    expect(rendered).to have_link('request a TRN', href: request_a_trn_path)
  end

  it 'includes a "Return to your ECTs" link that goes to the school home page' do
    expect(rendered).to have_link('Return to your ECTs', href: school_home_path)
  end
end
