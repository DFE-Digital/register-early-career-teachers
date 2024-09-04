require "rails_helper"

RSpec.describe Sessions::OTPSignInForm, type: :model do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:code).on(:verify).with_message("Enter the 6-digit code from the email") }

  describe "#code_is_verified" do
    let(:email) { "bob@example.com" }
    let(:code) { "123456" }
    let(:result) { 987_654 }
    let!(:user) { FactoryBot.create(:user, email:) }

    let(:mock_otp_service) { instance_double(Sessions::OneTimePassword, user: User.new(email:)) }
    subject(:form) { Sessions::OTPSignInForm.new(email:, code:) }

    before do
      allow(mock_otp_service).to receive(:verify).with(code:).and_return(result)
      allow(form).to receive(:otp).and_return(mock_otp_service)
    end

    it "does not add any errors" do
      expect(form.valid?(:verify)).to be true
      expect(form.errors).to be_empty
    end

    context "when the code is badly formed" do
      let(:code) { "banana" }

      it "adds an error" do
        expect(form.valid?(:verify)).to be false
        expect(form.errors.messages[:code]).to include "Enter the 6-digit code from the email"
      end
    end

    context "when the code does not verify" do
      let(:result) { nil }

      it "adds an error" do
        expect(form.valid?(:verify)).to be false
        expect(form.errors.messages[:code]).to include "The code entered is invalid"
      end
    end

    context "when there is no matching user" do
      let!(:user) { nil }

      it "does not verify the code" do
        expect(mock_otp_service).not_to receive(:verify)
        form.valid?(:verify)
      end

      it "adds an error" do
        expect(form.valid?(:verify)).to be false
        expect(form.errors.messages[:code]).to include "The code entered is invalid"
      end
    end
  end
end
