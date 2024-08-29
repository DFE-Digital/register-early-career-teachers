require 'rails_helper'

RSpec.describe "Admin", type: :request do
  describe "GET /admin" do
    it "redirects to sign-in" do
      get "/admin"
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
