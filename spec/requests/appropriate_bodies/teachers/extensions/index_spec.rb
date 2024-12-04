require 'rails_helper'

RSpec.describe "Appropriate Body teacher extensions index", type: :request do
  include AuthHelper
  let(:appropriate_body) { FactoryBot.create(:appropriate_body) }
  let(:teacher) { FactoryBot.create(:teacher) }
  let!(:induction_period) { FactoryBot.create(:induction_period, :active, teacher: teacher, appropriate_body: appropriate_body) }

  describe 'when not signed in' do
    it 'redirects to the signin page' do
      get("/appropriate-body/teachers/#{teacher.trn}/extensions")

      expect(response).to be_redirection
      expect(response.redirect_url).to end_with('/sign-in')
    end
  end

  describe 'when signed in as an appropriate body user' do
    let!(:user) { sign_in_as(:appropriate_body_user, appropriate_body:) }

    describe 'GET /appropriate-body/teachers/:trn/extensions' do
      it 'displays the extensions list' do
        FactoryBot.create(:induction_extension, teacher: teacher, number_of_terms: 2)

        get("/appropriate-body/teachers/#{teacher.trn}/extensions")

        expect(response).to be_successful
        expect(response.body).to include('2.0 terms')
      end
    end
  end
end
