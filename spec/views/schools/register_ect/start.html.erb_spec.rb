RSpec.describe "schools/register_ect/start.html.erb" do
  let(:continue_path) { schools_register_ect_find_ect_path }
  let(:title) { "What you'll need to register a new ECT" }

  it "sets the page title to 'What you'll need to register a new ECT'" do
    render

    expect(sanitize(view.content_for(:page_title))).to eql(sanitize(title))
  end

  it 'includes a continue button that links to the find ECT page' do
    render

    expect(rendered).to have_link('Continue', href: continue_path)
  end
end
