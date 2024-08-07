require "rails_helper"

RSpec.describe ExampleMailer, type: :mailer do
  describe "hello_world" do
    let(:from) { "from@example.com" }
    let(:to) { "test@example.com" }
    let(:subject) { "Hello world" }
    let(:salutation) { "Most excellent to see you!" }
    let(:mail) { ExampleMailer.with(from:, to:, subject:, salutation:).hello_world }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([to])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include "Here are some useless points"
    end

    context "when :salutation is missing" do
      it "raises an error" do
        expect {
          ExampleMailer.with(from:, to:, subject:).hello_world.deliver_now!
        }.to raise_error(KeyError).with_message("key not found: :salutation")
      end
    end
  end
end
