RSpec.describe 'Visiting the service' do
  let(:page) { RSpec.configuration.playwright_page }
  let(:current_path) { URI.parse(page.url).path }

  context 'when the schools interface is disabled' do
    before do
      allow(Rails.application.config).to receive(:enable_schools_interface).and_return(false)
    end

    scenario 'the home page is the approprate body landing page' do
      given_i_browse_to_the_app_root
      i_am_redirected_to_the_ab_landing_page
    end
  end

  context 'when the schools interface is enabled' do
    before do
      allow(Rails.application.config).to receive(:enable_schools_interface).and_return(true)
    end

    scenario 'the home page is the school page' do
      given_i_browse_to_the_app_root
      then_i_see_the_school_landing_page
    end
  end

private

  def given_i_browse_to_the_app_root
    path = '/'
    page.goto(path)
  end

  def i_am_redirected_to_the_ab_landing_page
    expect(current_path).to eql('/appropriate-body')
    expect(page.title).to include('Record induction as an appropriate body')
  end

  def then_i_see_the_school_landing_page
    expect(current_path).to eql('/')
    expect(page.title).to include('Register early career teachers')
  end
end
