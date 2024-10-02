require 'rails_helper'

RSpec.describe AppropriateBodies::ClaimAnECT::RegisterECT do
  let(:appropriate_body) { FactoryBot.create(:appropriate_body) }
  let(:pending_induction_submission) { FactoryBot.create(:pending_induction_submission) }

  subject { described_class.new(appropriate_body:, pending_induction_submission:) }

  describe "#initialize" do
    it "assigns the provided appropriate body and pending induction submission" do
      expect(subject.appropriate_body).to eq(appropriate_body)
      expect(subject.pending_induction_submission).to eq(pending_induction_submission)
    end
  end

  describe "#register" do
    let(:pending_induction_submission_params) do
      {
        induction_programme: "fip",
        started_on: Date.new(2023, 5, 3),
        finished_on: Date.new(2024, 5, 2),
        trn: "1234567",
        trs_first_name: "John",
        trs_last_name: "Doe"
      }
    end

    context "when registering a new teacher" do
      it "creates a new teacher and induction period" do
        expect {
          subject.register(pending_induction_submission_params)
        }.to change(Teacher, :count).by(1)
          .and change(InductionPeriod, :count).by(1)

        teacher = Teacher.last
        expect(teacher.first_name).to eq("John")
        expect(teacher.last_name).to eq("Doe")
        expect(teacher.trn).to eq("1234567")

        induction_period = InductionPeriod.last
        expect(induction_period.teacher).to eq(teacher)
        expect(induction_period.started_on).to eq(Date.new(2023, 5, 3))
        expect(induction_period.finished_on).to eq(Date.new(2024, 5, 2))
        expect(induction_period.appropriate_body).to eq(appropriate_body)
        expect(induction_period.induction_programme).to eq("fip")
      end

      it "enqueues BeginECTInductionJob" do
        expect {
          subject.register(pending_induction_submission_params)
        }.to have_enqueued_job(BeginECTInductionJob)
          .with(hash_including(trn: "1234567", start_date: "2023-05-03"))
      end
    end

    context "when registering an existing teacher without an induction period" do
      let!(:existing_teacher) { FactoryBot.create(:teacher, trn: "1234567") }

      it "updates the existing teacher and creates a new induction period" do
        expect {
          subject.register(pending_induction_submission_params)
        }.to change(Teacher, :count).by(0)
          .and change(InductionPeriod, :count).by(1)

        existing_teacher.reload
        expect(existing_teacher.first_name).to eq("John")
        expect(existing_teacher.last_name).to eq("Doe")

        induction_period = InductionPeriod.last
        expect(induction_period.teacher).to eq(existing_teacher)
      end
    end

    xcontext "when the teacher already has an induction period" do
      let!(:existing_teacher) { FactoryBot.create(:teacher, trn: "1234567") }
      let!(:existing_induction_period) { FactoryBot.create(:induction_period, teacher: existing_teacher) }

      it "raises TeacherAlreadyClaimedError" do
        expect {
          subject.register(pending_induction_submission_params)
        }.to raise_error(AppropriateBodies::Errors::TeacherAlreadyClaimedError, "Teacher already claimed")
      end
    end

    it "assigns provided params to the pending_induction_submission" do
      subject.register(pending_induction_submission_params)

      expect(subject.pending_induction_submission.induction_programme).to eq("fip")
      expect(subject.pending_induction_submission.started_on).to eq(Date.new(2023, 5, 3))
      expect(subject.pending_induction_submission.finished_on).to eq(Date.new(2024, 5, 2))
    end
  end
end
