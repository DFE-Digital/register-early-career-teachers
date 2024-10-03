RSpec.describe Sessions::OneTimePassword do
  let(:user) { FactoryBot.create(:user) }
  subject(:service) { Sessions::OneTimePassword.new(user:) }

  describe "#generate" do
    it "returns a OTP code" do
      expect(service.generate).to match(/\A\d{6}\z/)
    end

    it "sets a secret on the user" do
      expect { service.generate }.to(change { user.otp_secret })
    end
  end

  describe "#generate_and_send_code" do
    it "calls generate" do
      expect(service).to receive(:generate).once
      service.generate_and_send_code
    end

    it "sends an email to the user" do
      allow(service).to receive(:generate).and_return("123456")

      expect {
        service.generate_and_send_code
      }.to have_enqueued_mail(OTPMailer, :otp_code_email).with(params: { recipient_email: user.email,
                                                                         recipient_name: user.name,
                                                                         code: "123456" },
                                                               args: [])
    end
  end

  describe "#verify" do
    context "when the code is valid" do
      it "returns true" do
        code = service.generate
        expect(service.verify(code:)).to be true
      end

      it "updates the otp_verified_at timestamp" do
        code = service.generate
        expect { service.verify(code:) }.to(change { user.otp_verified_at })
      end
    end

    context "when the code has already been verified" do
      it "returns false" do
        code = service.generate
        service.verify(code:)

        expect(service.verify(code:)).to be false
      end

      it "does not update the otp_verified_at timestamp" do
        code = service.generate
        service.verify(code:)

        expect { service.verify(code:) }.not_to(change { user.otp_verified_at })
      end
    end

    context "when the code has expired" do
      it "returns false" do
        code = service.generate
        travel_to 11.minutes.from_now do
          expect(service.verify(code:)).to be false
        end
      end

      it "does not update the otp_verified_at timestamp" do
        code = service.generate

        travel_to 11.minutes.from_now do
          expect { service.verify(code:) }.not_to(change { user.otp_verified_at })
        end
      end
    end
  end
end
