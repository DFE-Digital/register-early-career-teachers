shared_context 'fake trs api client' do
  before do
    allow(TRS::APIClient).to receive(:new).and_return(TRS::FakeAPIClient.new)
  end
end

shared_context 'fake trs api client that finds nothing' do
  before do
    allow(TRS::APIClient).to receive(:new).and_return(TRS::FakeAPIClient.new(raise_not_found: true))
  end
end
