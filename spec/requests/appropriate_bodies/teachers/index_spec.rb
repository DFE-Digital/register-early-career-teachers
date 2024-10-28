require 'rails_helper'

RSpec.describe "Appropriate Body landing page", type: :request do
  include AuthHelper
  let(:appropriate_body) { user.appropriate_bodies.first }

  describe 'GET /appropriate-body/teachers' do
    context 'when not signed in' do
      it 'redirects to the signin page' do
        get("/appropriate-body/teachers")

        expect(response).to be_redirection
        expect(response.redirect_url).to end_with('/sign-in')
      end
    end

    context 'when signed in as an appropriate body user' do
      let!(:user) { sign_in_as(:appropriate_body_user) }
      let!(:emma) { FactoryBot.create(:teacher, first_name: 'Emma') }
      let!(:john) { FactoryBot.create(:teacher, first_name: 'John') }

      it 'finds the right PendingInductionSubmission record and renders the page' do
        get("/appropriate-body/teachers")

        expect(response).to be_successful
        expect(response.body).to include(emma.first_name, john.first_name)
      end

      context "with a query parameter" do
        it "filters the list of teachers" do
          get("/appropriate-body/teachers?q=emma")
          expect(response).to be_successful

          expect(response.body).to include(emma.first_name)
          expect(response.body).not_to include(john.first_name)
        end
      end
    end
  end
end
