require "rails_helper"

RSpec.describe "Admin root", type: :request do
  describe "GET /admin" do
    it "redirects to sign-in" do
      get "/admin"
      expect(response).to redirect_to(sign_in_path)
    end

    context "with an authenticated non-DfE user" do
      include_context 'fake session manager for non-DfE user'

      it "requires authorisation" do
        get "/admin"
        expect(response.status).to eq(401)
      end
    end

    context "with an authenticated DfE user" do
      include_context 'fake session manager for DfE user'

      it "shows the teachers index" do
        get "/admin"
        expect(response.status).to eq(200)
        expect(response.body).to include("Early career teachers")
      end

      it "shows the search interface" do
        get "/admin"
        expect(response.status).to eq(200)
        expect(response.body).to include("Search for an ECT")
        expect(response.body).to include("Filter by appropriate body")
      end

      it "lists appropriate bodies in the filter" do
        ab1 = FactoryBot.create(:appropriate_body, name: "Test AB 1")
        ab2 = FactoryBot.create(:appropriate_body, name: "Test AB 2")

        get "/admin"

        expect(response.status).to eq(200)
        expect(response.body).to include(ab1.name)
        expect(response.body).to include(ab2.name)
      end
    end
  end
end
