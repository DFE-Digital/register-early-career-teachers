RSpec.describe "schools/register_ect/induction_completed.html.erb" do
  let(:back_path) { schools_register_ect_find_ect_path }
  let(:ect) { double('ECT', full_name: 'John Doe') }
  let(:title) { "You cannot register #{ect.full_name}" }

  before do
    assign(:ect, ect)
  end

  it "sets the page title to 'You cannot register John Doe'" do
    render

    expect(sanitize(view.content_for(:page_title))).to eql(sanitize(title))
  end

  it "displays the ECT's full name in the body" do
    render

    expect(rendered).to have_text("Our records show John Doe has already completed their induction and therefore cannot be registered as an ECT.")
  end

  it "includes a link to register another ECT" do
    render

    expect(rendered).to have_link('Register another ECT', href: back_path)
  end
end
