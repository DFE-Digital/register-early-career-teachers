RSpec.describe "Admin", type: :request do
  describe "GET /admin/appropriate-bodies" do
    it "redirects to sign-in" do
      get "/admin/appropriate-bodies"
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
        get "/admin/appropriate-bodies"

        expect(response.status).to eq(401)
      end

      context "when DfE user" do
        before do
          FactoryBot.create(:dfe_role, user:)
        end

        let!(:appropriate_body1) { FactoryBot.create(:appropriate_body, name: "Captain Scrummy") }
        let!(:appropriate_body2) { FactoryBot.create(:appropriate_body, name: "Captain Hook") }

        it "display appropriate bodies" do
          get "/admin/appropriate-bodies"

          expect(response.status).to eq(200)
          expect(response.body).to include("Captain Scrummy", "Captain Hook")
        end

        context "when searching for appropriate bodies" do
          it "displays search results" do
            get "/admin/appropriate-bodies?q=Hook"
            expect(response.status).to eq(200)

            expect(response.body).to include("Captain Hook")
            expect(response.body).not_to include("Captain Scrummy")
          end
        end
      end
    end
  end
end
