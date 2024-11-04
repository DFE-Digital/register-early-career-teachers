RSpec.describe AppropriateBodies::ClaimAnECT::FindECT do
  let(:appropriate_body) { FactoryBot.build(:appropriate_body) }

  describe "#initialize" do
    let(:pending_induction_submission) { FactoryBot.create(:pending_induction_submission) }

    it "assigns the provided appropriate body and pending induction submission params" do
      find_ect = AppropriateBodies::ClaimAnECT::FindECT.new(appropriate_body:, pending_induction_submission:)

      expect(find_ect.appropriate_body).to eql(appropriate_body)
      expect(find_ect.pending_induction_submission).to eql(pending_induction_submission)
    end
  end

  describe "#import_from_trs!" do
    context "when the pending_induction_submission is invalid" do
      let(:pending_induction_submission) { FactoryBot.create(:pending_induction_submission, date_of_birth: nil) }

      it "returns nil" do
        find_ect = AppropriateBodies::ClaimAnECT::FindECT.new(appropriate_body:, pending_induction_submission:)

        expect(find_ect.import_from_trs!).to be_nil
      end
    end

    context "when there is a match" do
      it "makes a call to the TRS API client with the expected parameters"
      it "assigns the incoming attributes to the pending_induction_submission and returns it"
    end

    context "when there is a match and the teacher has an active induction period" do
      let(:teacher) { FactoryBot.create(:teacher) }
      let!(:pending_induction_submission) { FactoryBot.create(:pending_induction_submission, trn: teacher.trn) }
      let!(:induction_period) do
        FactoryBot.create(:induction_period, :active, appropriate_body:, teacher:, started_on: Date.parse("2 October 2022"))
      end

      context "when the induction period is with another AB" do
        let(:appropriate_body) { FactoryBot.create(:appropriate_body) }

        it "raises TeacherHasActiveInductionPeriodWithAnotherAB" do
          find_ect = AppropriateBodies::ClaimAnECT::FindECT.new(
            appropriate_body: FactoryBot.create(:appropriate_body), pending_induction_submission:
          )

          expect { find_ect.import_from_trs! }.to raise_error(AppropriateBodies::Errors::TeacherHasActiveInductionPeriodWithAnotherAB)
        end
      end

      context "when there's an open induction_period with the same AB" do
        let(:appropriate_body) { pending_induction_submission.appropriate_body }

        it "raises TeacherHasActiveInductionPeriodWithCurrentAB" do
          find_ect = AppropriateBodies::ClaimAnECT::FindECT.new(appropriate_body:, pending_induction_submission:)

          expect { find_ect.import_from_trs! }.to raise_error(AppropriateBodies::Errors::TeacherHasActiveInductionPeriodWithCurrentAB)
        end
      end
    end

    context "when there is no match" do
      include_context "fake trs api client that finds nothing"

      it "raises teacher not found error" do
        pending_induction_submission = FactoryBot.create(:pending_induction_submission)
        find_ect = AppropriateBodies::ClaimAnECT::FindECT.new(appropriate_body:, pending_induction_submission:)

        expect { find_ect.import_from_trs! }.to raise_error(TRS::Errors::TeacherNotFound)
      end
    end
  end
end
