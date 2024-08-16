require "rails_helper"

RSpec.describe OTPMailer, type: :mailer do
  describe "otp_code_email" do
    let(:from) { "from@example.com" }
    let(:recipient_email) { "chester@example.com" }
    let(:recipient_name) { "Chester Thompson" }
    let(:code) { "123456" }
    let(:mail) { OTPMailer.with(recipient_email:, recipient_name:, code:).otp_code_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Sign-in to ECF2 with this one time password")
      expect(mail.to).to eq([recipient_email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include recipient_name
      expect(mail.body.encoded).to include code
    end
  end
end
