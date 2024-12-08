shared_context 'fake session manager for non-DfE user' do
  let(:user) { FactoryBot.create(:user) }
  let(:session_manager) { instance_double(Sessions::SessionManager, provider: "developer", expires_at: 2.hours.from_now) }
  let(:fake_user) { double(Sessions::SessionUser, email: 'admin@example.org', name: 'sample admin', dfe_user?: false) }

  before do
    allow(Sessions::SessionManager).to receive(:new).and_return(session_manager)
    allow(session_manager).to receive(:load_from_session).and_return(fake_user)
  end
end

shared_context 'fake session manager for DfE user' do
  let(:session_manager) { instance_double(Sessions::SessionManager, provider: "developer", expires_at: 2.hours.from_now) }
  let(:fake_user) { double(Sessions::SessionUser, email: 'admin@example.org', name: 'sample admin', dfe_user?: true) }

  before do
    allow(Sessions::SessionManager).to receive(:new).and_return(session_manager)
    allow(session_manager).to receive(:load_from_session).and_return(fake_user)
  end
end
