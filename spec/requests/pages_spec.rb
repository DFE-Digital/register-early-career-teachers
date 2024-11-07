RSpec.describe "Pages", type: :request do
  describe "GET /" do
    context 'when ENABLE_SCHOOLS_INTERFACE is true' do
      before { allow(Rails.application.config).to receive(:enable_schools_interface).and_return(true) }

      it "returns http success" do
        get "/"
        expect(response).to have_http_status(:success)
      end
    end

    context 'when ENABLE_SCHOOLS_INTERFACE is false' do
      before { allow(Rails.application.config).to receive(:enable_schools_interface).and_return(false) }

      it 'redirects to the appropriate body landing page' do
        get "/"
        expect(response).to redirect_to(ab_landing_path)
      end
    end
  end
end
