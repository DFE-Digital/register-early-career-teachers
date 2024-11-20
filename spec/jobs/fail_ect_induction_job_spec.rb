RSpec.describe FailECTInductionJob, type: :job do
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:teacher_id) { teacher.id }
  let(:trn) { teacher.trn }
  let(:completion_date) { "2024-01-13" }
  let!(:pending_induction_submission_id) { FactoryBot.create(:pending_induction_submission).id }
  let(:api_client) { instance_double(TRS::APIClient) }

  before do
    allow(TRS::APIClient).to receive(:new).and_return(api_client)
  end

  describe '#perform' do
    context "when the API call is successful" do
      before do
        allow(api_client).to receive(:fail_induction!)
          .with(trn:, completion_date:)
      end

      it "calls the API client with correct parameters" do
        expect(api_client).to receive(:fail_induction!)
          .with(trn:, completion_date:)

        described_class.perform_now(
          trn:,
          completion_date:,
          pending_induction_submission_id:,
          teacher_id:
        )
      end

      it "updates the teacher's induction_completion_date_submitted_to_trs_at" do
        freeze_time do
          expect {
            described_class.perform_now(trn:, completion_date:, teacher_id:, pending_induction_submission_id:)
          }.to change { teacher.reload.induction_completion_submitted_to_trs_at }.from(nil).to(Time.zone.now)
        end
      end

      it "destroys the pending induction submission" do
        expect {
          described_class.perform_now(trn:, completion_date:, teacher_id:, pending_induction_submission_id:)
        }.to change { PendingInductionSubmission.count }.by(-1)
      end
    end
  end
end
