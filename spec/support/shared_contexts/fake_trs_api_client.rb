shared_context 'fake_trs_api_client' do
  before do
    allow(TRS::APIClient).to receive(:new).and_return(TRS::FakeAPIClient.new)
  end
end
