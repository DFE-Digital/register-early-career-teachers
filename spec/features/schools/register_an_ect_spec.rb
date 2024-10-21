RSpec.describe 'Registering an ECT' do
  let(:page) { RSpec.configuration.playwright_page }

  before { sign_in_as_admin }

  scenario 'Happy path' do
    given_i_am_on_the_start_page
    when_i_click_on_the_continue_link
    i_should_be_taken_to_the_find_ect_page

    when_i_fill_in_the_find_ect_form
    and_i_click_on_the_continue_button
    then_i_should_be_taken_to_the_review_ect_details_page
  end

  def given_i_am_on_the_start_page
    path = '/schools/what-you-will-need'
    page.goto path
    expect(page.url).to end_with(path)
  end

  def when_i_click_on_the_continue_link
    page.click('text=Continue')
  end

  def i_should_be_taken_to_the_find_ect_page
    path = '/schools/find-ect'
    expect(page.url).to end_with(path)
  end

  def when_i_fill_in_the_find_ect_form
    page.fill('#find-ect-trn-field', '1234567')

    page.fill('#find_ect_date_of_birth_3i', '10')
    page.fill('#find_ect_date_of_birth_2i', '12')
    page.fill('#find_ect_date_of_birth_1i', '1990')
  end

  def and_i_click_on_the_continue_button
    page.click('text=Continue')
  end

  def then_i_should_be_taken_to_the_review_ect_details_page
    path = '/schools/review-ect-details'
    expect(page.url).to end_with(path)
  end
end
