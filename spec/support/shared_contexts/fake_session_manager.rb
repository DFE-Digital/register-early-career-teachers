shared_context 'fake session manager for non-DfE user' do
  let(:user) { FactoryBot.create(:user) }
  let(:session_manager) do
    instance_double(Sessions::SessionManager, provider: "developer", expires_at: 2.hours.from_now)
  end

  before do
    allow(Sessions::SessionManager).to receive(:new).and_return(session_manager)
    allow(session_manager).to receive(:load_from_session).and_return(user)
  end
end

shared_context 'fake session manager for DfE user' do
  let(:user) { FactoryBot.create(:user) }
  let(:session_manager) do
    instance_double(Sessions::SessionManager, provider: "developer", expires_at: 2.hours.from_now)
  end

  before do
    allow(Sessions::SessionManager).to receive(:new).and_return(session_manager)
    allow(session_manager).to receive(:load_from_session).and_return(user)
    FactoryBot.create(:dfe_role, user:)
  end
end
