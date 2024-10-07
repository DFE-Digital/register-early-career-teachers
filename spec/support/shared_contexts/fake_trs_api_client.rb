shared_context 'fake trs api client' do
  before do
    allow(TRS::APIClient).to receive(:new).and_return(TRS::FakeAPIClient.new)
  end
end
