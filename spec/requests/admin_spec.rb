RSpec.describe "Admin", type: :request do
  describe "GET /admin" do
    it "redirects to sign-in" do
      get "/admin"
      expect(response).to redirect_to(sign_in_path)
    end

    context "with an authenticated user" do
      include_context 'fake session manager for non-DfE user'

      context "when the user isn't a DfE user" do
        it "requires authorisation" do
          get "/admin"

          expect(response.status).to eq(401)
        end
      end

      context 'when the user is a DfE user' do
        include_context 'fake session manager for DfE user'

        it "allows access to DfE users" do
          get "/admin"
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
