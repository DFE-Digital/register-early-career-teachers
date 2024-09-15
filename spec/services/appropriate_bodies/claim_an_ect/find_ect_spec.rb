require 'rails_helper'

RSpec.describe AppropriateBodies::ClaimAnECT::FindECT do
  describe "#initialize" do
    let(:appropriate_body) { FactoryBot.build(:appropriate_body) }
    let(:pending_induction_submission_params) do
      {
        trn: "0123456",
        "date_of_birth(3)" => "1",
        "date_of_birth(2)" => "11",
        "date_of_birth(1)" => "1995",
      }
    end

    it "assigns the provided appropriate body and pending induction submission params" do
      find_ect = AppropriateBodies::ClaimAnECT::FindECT.new(appropriate_body:, pending_induction_submission_params:)

      expect(find_ect.appropriate_body).to eql(appropriate_body)
      expect(find_ect.pending_induction_submission.trn).to eql("0123456")
      expect(find_ect.pending_induction_submission.date_of_birth).to eql(Date.new(1995, 11, 1))
    end
  end

  describe "#import_from_trs" do
    context "when there is a match" do
      it "makes a call to the TRS API client with the expected parameters"
      it "assigns the incoming attributes to the pending_induction_submission and returns it"
    end

    context "when there is no match" do
      it "adds an error to the pending_induction_submission base"
    end
  end
end
