module AppropriateBodies
  module ClaimAnECT
    class RegisterECT
      attr_reader :appropriate_body, :pending_induction_submission

      def initialize(appropriate_body:, pending_induction_submission:)
        @appropriate_body = appropriate_body
        @pending_induction_submission = pending_induction_submission
      end

      def register(pending_induction_submission_params)
        pending_induction_submission.assign_attributes(**pending_induction_submission_params)

        return pending_induction_submission unless pending_induction_submission.valid?(:register_ect)

        teacher = Teacher.find_or_initialize_by(trn: pending_induction_submission.trn)

        if teacher.persisted? && teacher.induction_periods_reported_by_appropriate_body.present?
          raise AppropriateBodies::Errors::TeacherAlreadyClaimedError, "Teacher already claimed"
        end

        ActiveRecord::Base.transaction do
          teacher.update!(
            first_name: pending_induction_submission.trs_first_name,
            last_name: pending_induction_submission.trs_last_name
          )
          InductionPeriod.create!(
            teacher:,
            started_on: pending_induction_submission.started_on,
            appropriate_body:,
            induction_programme: pending_induction_submission.induction_programme
          )
          BeginECTInductionJob.perform_later(
            trn: pending_induction_submission.trn,
            start_date: pending_induction_submission.started_on.to_s,
            teacher_id: teacher.id,
            pending_induction_submission_id: pending_induction_submission.id
          )
        end

        pending_induction_submission
      end
    end
  end
end
