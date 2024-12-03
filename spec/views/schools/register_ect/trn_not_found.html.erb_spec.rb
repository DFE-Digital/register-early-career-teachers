RSpec.describe "schools/register_ect/trn_not_found.html.erb" do
  let(:back_path) { schools_ects_home_path }
  let(:find_a_lost_trn_path) { "https://find-a-lost-trn.education.gov.uk/start" }
  let(:review_teacher_record_path) { "https://check-a-teachers-record.education.gov.uk/check-records/sign-in" }
  let(:try_again_path) { schools_register_ect_find_ect_path }
  let(:title) { "We're unable to match the ECT with the TRN you provided" }

  it "sets the page title to 'We're unable to match the ECT with the TRN you provided'" do
    render

    expect(sanitize(view.content_for(:page_title))).to eql(sanitize(title))
  end

  it 'includes no back button' do
    render

    expect(view.content_for(:backlink_or_breadcrumb)).to be_blank
  end

  it 'includes a link to reviewing the teacher record' do
    render

    expect(rendered).to have_link('reviewing their teacher record', href: review_teacher_record_path)
  end

  it 'includes a link to the Find a lost TRN service' do
    render

    expect(rendered).to have_link('Find a lost TRN service', href: find_a_lost_trn_path)
  end

  it 'includes a try again button that links to the find ECT page' do
    render

    expect(rendered).to have_link('Try again', href: try_again_path)
  end
end
