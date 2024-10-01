require 'rails_helper'

RSpec.describe AppropriateBodies::ClaimAnECT::CheckECT do
  let(:appropriate_body) { FactoryBot.build(:appropriate_body) }
  let(:pending_induction_submission) { FactoryBot.create(:pending_induction_submission) }

  subject { AppropriateBodies::ClaimAnECT::CheckECT.new(appropriate_body:, pending_induction_submission:) }

  describe "#initialize" do
    it "assigns the provided appropriate body and pending induction submission params" do
      expect(subject.appropriate_body).to eql(appropriate_body)
      expect(subject.pending_induction_submission).to eql(pending_induction_submission)
    end
  end

  describe "#confirm_info_correct" do
    context "when confirmed = true (box is checked)" do
      before { subject.confirm_info_correct(true) }

      it "sets the confirmed attribute to true" do
        expect(subject.pending_induction_submission.confirmed).to be(true)
      end

      it "sets confirmed_at timestamp to now" do
        expect(subject.pending_induction_submission.confirmed_at).to be_within(1.second).of(Time.zone.now)
      end

      it "results in the pending_induction_submission being valid" do
        expect(subject.pending_induction_submission).to be_valid(:check_ect)
      end
    end

    context "when confirmed = false (box isn't checked)" do
      before { subject.confirm_info_correct(false) }

      it "sets the confirmed attribute to false" do
        expect(subject.pending_induction_submission.confirmed).to be(false)
      end

      it "leaves the confirmed_at timestamp blank" do
        expect(subject.pending_induction_submission.confirmed_at).to be_nil
      end

      it "results in the pending_induction_submission being invalid" do
        expect(subject.pending_induction_submission).to be_invalid(:check_ect)
      end
    end
  end
end
