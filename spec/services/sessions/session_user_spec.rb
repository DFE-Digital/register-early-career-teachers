RSpec.describe Sessions::SessionUser do
  describe '.initialize' do
    let(:last_active_at) { 2.minutes.ago }

    it 'initializes correctly' do
      session_user = Sessions::SessionUser.new(
        provider: 'otp',
        name: 'Peter Cushing',
        email: 'pc@example.com',
        last_active_at:,
        dfe: true
      )

      expect(session_user.provider).to eql('otp')
      expect(session_user.name).to eql('Peter Cushing')
      expect(session_user.email).to eql('pc@example.com')
      expect(session_user.last_active_at).to eql(last_active_at)
      expect(session_user.dfe).to be(true)
    end
  end

  describe '.from_session' do
    let(:last_active_at) { 4.minutes.ago }

    it 'loads a new SessionUser from the provided hash (session["user_session"])' do
      fake_user_session = {
        'provider' => 'developer',
        'name' => 'Christopher Lee',
        'email' => 'cl@example.com',
        'last_active_at' => last_active_at,
        'appropriate_body_id' => 23
      }

      session_user = Sessions::SessionUser.from_session(fake_user_session)

      expect(session_user.provider).to eql('developer')
      expect(session_user.name).to eql('Christopher Lee')
      expect(session_user.email).to eql('cl@example.com')
      expect(session_user.last_active_at).to eql(last_active_at)
      expect(session_user.appropriate_body_id).to be(23)
    end
  end

  describe '.from_user_record' do
    let(:last_active_at) { 6.minutes.ago }

    it 'finds the corresponding user record with the given email and sets the SessionUser up approrpiately' do
      user = FactoryBot.create(:user)

      session_user = Sessions::SessionUser.from_user_record(email: user.email, provider: 'otp')

      expect(session_user.name).to eql(user.name)
      expect(session_user.email).to eql(user.email)
      expect(session_user.provider).to eql('otp')
    end
  end

  describe '#record_new_activity!' do
    it 'updates the provided session hash with the default timestamp (now)' do
      fake_session = { 'user_session' => { 'last_active_at' => 5.minutes.ago } }
      session_user = Sessions::SessionUser.new(provider: 'test', email: 'Nicolas Cage')
      session_user.record_new_activity!(session: fake_session)

      expect(fake_session['user_session']['last_active_at']).to be_within(1.second).of(Time.zone.now)
    end

    context 'when a time is provided' do
      it 'updates the provided session hash with the given timestamp' do
        fake_session = { 'user_session' => { 'last_active_at' => 5.minutes.ago } }
        session_user = Sessions::SessionUser.new(provider: 'test', email: 'Nicolas Cage')
        session_user.record_new_activity!(session: fake_session, time: 2.minutes.ago)

        expect(fake_session['user_session']['last_active_at']).to be_within(1.second).of(2.minutes.ago)
      end
    end
  end

  describe '#appropriate_body_user?' do
    it 'is true with appropriate_body_id is present' do
      session_user = Sessions::SessionUser.new(email: 'test@example.com', provider: 'otp', appropriate_body_id: 123)

      expect(session_user).to be_appropriate_body_user
    end

    it 'is false with appropriate_body_id is missing' do
      session_user = Sessions::SessionUser.new(email: 'test@example.com', provider: 'otp')

      expect(session_user).not_to be_appropriate_body_user
    end
  end

  describe '#school_user?' do
    it 'is true with school_urn is present' do
      session_user = Sessions::SessionUser.new(email: 'test@example.com', provider: 'otp', school_urn: 123_456)

      expect(session_user).to be_school_user
    end

    it 'is false with school_urn is missing' do
      session_user = Sessions::SessionUser.new(email: 'test@example.com', provider: 'otp')

      expect(session_user).not_to be_school_user
    end
  end

  describe '#dfe_user?' do
    it 'is true with dfe is true' do
      session_user = Sessions::SessionUser.new(email: 'test@example.com', provider: 'otp', dfe: true)

      expect(session_user).to be_dfe_user
    end

    it 'is false with dfe is missing' do
      session_user = Sessions::SessionUser.new(email: 'test@example.com', provider: 'otp')

      expect(session_user).not_to be_dfe_user
    end

    it 'is false with dfe is false' do
      session_user = Sessions::SessionUser.new(email: 'test@example.com', provider: 'otp', dfe: false)

      expect(session_user).not_to be_dfe_user
    end
  end

  describe '#to_h' do
    let(:last_active_at) { 8.minutes.ago }

    it 'returns all relevant attribtues in a hash' do
      session_user = Sessions::SessionUser.new(
        provider: 'otp',
        name: 'Bela Lugosi',
        email: 'bl@example.com',
        last_active_at:,
        appropriate_body_id: 1234
      )

      expect(session_user.to_h).to eql(
        {
          "provider" => 'otp',
          "email" => 'bl@example.com',
          "name" => 'Bela Lugosi',
          "last_active_at" => last_active_at,
          "appropriate_body_id" => 1234,
          "school_urn" => nil,
          "dfe" => false
        }
      )
    end
  end
end
