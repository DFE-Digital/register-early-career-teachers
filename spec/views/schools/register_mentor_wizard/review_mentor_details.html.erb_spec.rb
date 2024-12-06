require 'ostruct'

RSpec.describe "schools/register_mentor_wizard/review_mentor_details.html.erb" do
  let(:back_path) { schools_register_mentor_wizard_find_mentor_path }
  let(:date_of_birth) { "1950/1/1" }
  let(:confirm_and_continue_path) { schools_register_mentor_wizard_review_mentor_details_path }
  let(:national_insurance_number) { "AD12345ED" }
  let(:title) { "Check mentor details" }
  let(:store) do
    OpenStruct.new(trn: "1234567",
                   trs_first_name: "John",
                   trs_last_name: "Wayne",
                   trs_date_of_birth: "1950-01-01",
                   date_of_birth:,
                   national_insurance_number:)
  end
  let(:wizard) { Schools::RegisterMentorWizard::Wizard.new(current_step: :review_mentor_details, store:) }
  let(:mentor) { wizard.mentor }

  before do
    assign(:wizard, wizard)
    assign(:mentor, mentor)
  end

  it "sets the page title to 'Check mentor details'" do
    render

    expect(sanitize(view.content_for(:page_title))).to eql(sanitize(title))
  end

  it 'includes a back button that links to trn and dob page of the journey' do
    render

    expect(view.content_for(:backlink_or_breadcrumb)).to have_link('Back', href: back_path)
  end

  it 'displays Name and TRN' do
    render

    expect(rendered).to have_element(:dt, text: "Name")
    expect(rendered).to have_element(:dd, text: "John Wayne")
    expect(rendered).to have_element(:dt, text: "Teacher Reference Number (TRN)")
    expect(rendered).to have_element(:dd, text: "1234567")
  end

  context "when the TRN and DoB match a TRS record" do
    it 'displays the Date of Birth' do
      render

      expect(rendered).to have_element(:dt, text: "Date of birth")
      expect(rendered).to have_element(:dd, text: "1 January 1950")
      expect(rendered).not_to have_element(:dt, text: "National Insurance Number")
    end
  end

  context "when the TRN and NINo match a TRS record" do
    before do
      store.date_of_birth = "1950-01'02"
    end

    it 'displays the National insurance number' do
      render

      expect(rendered).to have_element(:dt, text: "National insurance number")
      expect(rendered).to have_element(:dd, text: "AD12345ED")
      expect(rendered).not_to have_element(:dt, text: "Date of birth")
    end
  end

  it 'includes a Confirm and continue button that posts to the review mentor details page' do
    render

    expect(rendered).to have_button('Confirm and continue')
    expect(rendered).to have_selector("form[action='#{confirm_and_continue_path}']")
  end

  it "includes a 'check details' link to the trn and dob page of the journey" do
    render

    expect(rendered).to have_link('check details', href: back_path)
  end
end
