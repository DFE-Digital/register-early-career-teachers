module AppropriateBodies
  module ClaimAnECT
    class CheckECT
      attr_reader :appropriate_body, :pending_induction_submission, :confirmed

      def initialize(appropriate_body:, pending_induction_submission:)
        @appropriate_body = appropriate_body
        @pending_induction_submission = pending_induction_submission
      end

      def confirm_info_correct(confirmed)
        pending_induction_submission.tap do |submission|
          submission.confirmed = confirmed
          submission.confirmed_at = Time.zone.now if confirmed
        end

        pending_induction_submission.save(context: :check_ect)
      end
    end
  end
end
