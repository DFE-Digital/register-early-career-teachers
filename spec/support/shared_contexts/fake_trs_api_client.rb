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

shared_context 'fake trs api client returns 200 then 400' do
  before do
    allow(TRS::APIClient).to receive(:new).and_return(
      TRS::FakeAPIClient.new,
      TRS::FakeAPIClient.new(raise_not_found: true)
    )
  end
end

shared_context 'fake trs api client that finds teacher without QTS' do
  before do
    allow(TRS::APIClient).to receive(:new).and_return(TRS::FakeAPIClient.new(include_qts: false))
  end
end

shared_context 'fake trs api client that finds teacher prohibited from teaching' do
  before do
    allow(TRS::APIClient).to receive(:new).and_return(TRS::FakeAPIClient.new(prohibited_from_teaching: true))
  end
end

shared_context 'fake trs api client that finds teacher with invalid induction status' do |status|
  before do
    allow(TRS::APIClient).to receive(:new).and_return(TRS::FakeAPIClient.new(induction_status: status))
  end
end

shared_context 'fake trs api client that finds teacher that has passed their induction' do
  before do
    allow(TRS::APIClient).to receive(:new).and_return(TRS::FakeAPIClient.new(induction_status: 'Pass'))
  end
end

shared_context 'fake trs api client that finds teacher that is exempt from induction' do
  before do
    allow(TRS::APIClient).to receive(:new).and_return(TRS::FakeAPIClient.new(induction_status: 'Exempt'))
  end
end

shared_context 'fake trs api returns a teacher and then a teacher that has completed their induction' do
  before do
    allow(TRS::APIClient).to receive(:new).and_return(
      TRS::FakeAPIClient.new,
      TRS::FakeAPIClient.new(induction_status: 'Pass')
    )
  end
end

shared_context 'fake trs api returns a teacher and then a teacher that is exempt from induction' do
  before do
    allow(TRS::APIClient).to receive(:new).and_return(
      TRS::FakeAPIClient.new,
      TRS::FakeAPIClient.new(induction_status: 'Exempt')
    )
  end
end
