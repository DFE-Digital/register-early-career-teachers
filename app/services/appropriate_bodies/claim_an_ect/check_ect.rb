module AppropriateBodies
  module ClaimAnECT
    class CheckECT
      attr_reader :appropriate_body, :pending_induction_submission, :confirmed

      def initialize(appropriate_body:, pending_induction_submission_id:)
        # FIXME: find within the scope of the current AB

        @appropriate_body = appropriate_body
        @pending_induction_submission = PendingInductionSubmission.find(pending_induction_submission_id)
      end

      def confirm_info_correct(confirmed)
        pending_induction_submission.tap do |submission|
          submission.confirmed = confirmed
          submission.confirmed_at = Time.zone.now if confirmed
        end
      end
    end
  end
end
