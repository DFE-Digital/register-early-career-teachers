require "rails_helper"

RSpec.describe Sessions::SessionManager do
  let(:session) { HashWithIndifferentAccess.new }
  let(:email) { "eric@example.com" }
  let(:provider) { "otp" }

  subject(:service) { Sessions::SessionManager.new(session) }

  describe "#begin_session!" do
    it "creates a user_session hash in the session" do
      service.begin_session!(email, provider)
      expect(session["user_session"]).to be_present
    end

    it "stores the email in the session" do
      service.begin_session!(email, provider)
      expect(session["user_session"]["email"]).to eq email
    end

    it "stores the provider in the session" do
      service.begin_session!(email, provider)
      expect(session["user_session"]["provider"]).to eq provider
    end

    it "stores a last active timestamp in the session" do
      service.begin_session!(email, provider)
      expect(session["user_session"]["last_active_at"]).to be_within(1.second).of(Time.zone.now)
    end
  end

  describe "#load_from_session" do
    let!(:user) { FactoryBot.create(:user, email:) }

    before do
      session["user_session"] = { "email" => user.email, "provider" => provider, "last_active_at" => 10.minutes.ago }
    end

    it "returns the User associated with the session data" do
      expect(service.load_from_session).to eq user
    end

    it "updates the last_active_at timestamp" do
      service.load_from_session
      expect(session["user_session"]["last_active_at"]).to be_within(1.second).of(Time.zone.now)
    end

    context "when the session data is stale" do
      let(:last_active_at) { 3.hours.ago }

      before do
        session["user_session"] = { "email" => email, "provider" => provider, "last_active_at" => last_active_at }
      end

      it "returns nil" do
        expect(service.load_from_session).to be_nil
      end

      it "does not update the last_active_at timestamp" do
        service.load_from_session
        expect(session["user_session"]["last_active_at"]).to eq last_active_at
      end
    end

    context "when the email does not have an associated user record" do
      let(:last_active_at) { 2.minutes.ago }

      before do
        session["user_session"] = { "email" => "kenny@example.com", "provider" => provider, "last_active_at" => last_active_at }
      end

      it "returns nil" do
        expect(service.load_from_session).to be_nil
      end

      it "does not update the last_active_at timestamp" do
        service.load_from_session
        expect(session["user_session"]["last_active_at"]).to eq last_active_at
      end
    end
  end

  describe "#end_session!" do
    let(:session) { double("Session") }

    it "calls destroy on the session object" do
      expect(session).to receive(:destroy).once
      service.end_session!
    end
  end

  describe "#requested_path=" do
    let(:url) { "https://path.to/something/" }

    it "stores the requested path in the session" do
      service.requested_path = url
      expect(session["requested_path"]).to eq url
    end
  end

  describe "#requested_path" do
    let(:url) { "https://path.to/something/" }

    before do
      session["requested_path"] = url
    end

    it "returns the requested path from the session" do
      expect(service.requested_path).to eq url
    end

    it "removes the requested path from the session" do
      service.requested_path
      expect(session.keys.map(&:to_s)).not_to include "requested_path"
    end
  end
end
