require 'rails_helper'

RSpec.describe "Appropriate Body landing page", type: :request do
  include AuthHelper
  let(:appropriate_body) { user.appropriate_bodies.first }

  describe 'GET /appropriate-body' do
    it 'renders despite not being logged in' do
      get("/appropriate-body")

      expect(response).to be_successful
    end
  end
end
