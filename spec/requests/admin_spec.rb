require 'rails_helper'

RSpec.describe "Admin", type: :request do
  describe "GET /admin" do
    it "redirects to sign-in" do
      get "/admin"
      expect(response).to redirect_to(sign_in_path)
    end

    context "with an authenticated user" do
      let(:session_manager) do
        instance_double(Sessions::SessionManager, provider: "developer", expires_at: 2.hours.from_now)
      end
      let(:user) { FactoryBot.create(:user) }

      before do
        allow(Sessions::SessionManager).to receive(:new).and_return(session_manager)
        allow(session_manager).to receive(:load_from_session).and_return(user)
      end

      it "requires authorisation" do
        get "/admin"

        expect(response.status).to eq(401)
      end

      it "allows access to DfE users" do
        FactoryBot.create(:dfe_role, user:)

        get "/admin"
        expect(response.status).to eq(200)
      end
    end
  end
end
