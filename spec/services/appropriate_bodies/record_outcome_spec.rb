require "rails_helper"

RSpec.describe AppropriateBodies::RecordOutcome do
  subject(:service) do
    described_class.new(
      appropriate_body: appropriate_body,
      pending_induction_submission: pending_induction_submission,
      teacher: teacher
    )
  end

  let(:appropriate_body) { FactoryBot.create(:appropriate_body) }
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:induction_period) { FactoryBot.create(:induction_period, teacher: teacher) }
  let(:pending_induction_submission) do
    FactoryBot.create(:pending_induction_submission,
                      trn: teacher.trn,
                      finished_on: 1.day.ago.to_date,
                      number_of_terms: 6)
  end

  before do
    allow(Teachers::InductionPeriod).to receive(:new)
      .with(teacher)
      .and_return(double(active_induction_period: induction_period))
  end

  describe "#pass!" do
    context "when happy path" do
      it "updates the induction period with pass outcome" do
        service.pass!

        expect(induction_period.reload).to have_attributes(
          finished_on: pending_induction_submission.finished_on,
          outcome: "pass",
          number_of_terms: pending_induction_submission.number_of_terms
        )
      end

      it "enqueues a PassECTInductionJob" do
        expect {
          service.pass!
        }.to have_enqueued_job(PassECTInductionJob).with(
          trn: pending_induction_submission.trn,
          completion_date: pending_induction_submission.finished_on.to_s,
          pending_induction_submission_id: pending_induction_submission.id,
          teacher_id: teacher.id
        )
      end
    end

    context "when induction period update fails" do
      before do
        allow(induction_period).to receive(:update)
          .and_raise(ActiveRecord::RecordNotFound)
      end

      it "bubbles up the error" do
        expect { service.pass! }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "#fail!" do
    context "when successful" do
      it "updates the induction period with fail outcome" do
        service.fail!

        expect(induction_period.reload).to have_attributes(
          finished_on: pending_induction_submission.finished_on,
          outcome: "fail",
          number_of_terms: pending_induction_submission.number_of_terms
        )
      end

      it "enqueues a FailECTInductionJob" do
        expect {
          service.fail!
        }.to have_enqueued_job(FailECTInductionJob).with(
          trn: pending_induction_submission.trn,
          completion_date: pending_induction_submission.finished_on.to_s,
          pending_induction_submission_id: pending_induction_submission.id,
          teacher_id: teacher.id
        )
      end
    end

    context "when induction period update fails" do
      before do
        allow(induction_period).to receive(:update)
          .and_raise(ActiveRecord::RecordNotFound)
      end

      it "bubbles up the error" do
        expect { service.fail! }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
