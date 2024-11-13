module AppropriateBodies
  module ClaimAnECT
    class ErrorsController < AppropriateBodiesController
      before_action :find_pending_induction_submission

      def exempt_from_completing_induction = nil
      def induction_already_completed = nil
      def induction_with_another_appropriate_body = nil
      def no_qts = nil
      def prohibited_from_teaching = nil

    private

      def find_pending_induction_submission
        # FIXME: find within the scope of the current AB

        @pending_induction_submission = PendingInductionSubmission.find(params[:id])
      end
    end
  end
end
