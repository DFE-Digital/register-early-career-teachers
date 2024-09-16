require 'rails_helper'

RSpec.describe AppropriateBodies::ClaimAnECT::RegisterECT do
  let(:appropriate_body) { FactoryBot.build(:appropriate_body) }
  let(:pending_induction_submission) { FactoryBot.create(:pending_induction_submission) }
  let(:pending_induction_submission_id) { pending_induction_submission.id }

  subject { AppropriateBodies::ClaimAnECT::RegisterECT.new(appropriate_body:, pending_induction_submission_id:) }

  describe "#initialize" do
    it "assigns the provided appropriate body and pending induction submission params" do
      expect(subject.appropriate_body).to eql(appropriate_body)
      expect(subject.pending_induction_submission).to eql(pending_induction_submission)
    end
  end

  describe "#register" do
    let(:pending_induction_submission_params) do
      {
        induction_programme: "fip",
        "started_on(3)" => "3",
        "started_on(2)" => "5",
        "started_on(1)" => "2023",
      }
    end

    it "assigns any provided params to the object" do
      subject.register(pending_induction_submission_params)

      expect(subject.pending_induction_submission.induction_programme).to eql("fip")
      expect(subject.pending_induction_submission.started_on).to eql(Date.new(2023, 5, 3))
    end
  end
end
