module AppropriateBodies
  module ClaimAnECT
    class FindECTController < AppropriateBodiesController
      def new
        @pending_induction_submission = PendingInductionSubmission.new
      end

      def create
        @pending_induction_submission = AppropriateBodies::ClaimAnECT::FindECT
          .new(appropriate_body: @appropriate_body, pending_induction_submission_params:)
          .import_from_trs

        if @pending_induction_submission.save
          redirect_to(edit_ab_claim_an_ect_check_path(@pending_induction_submission))
        else
          render(:new)
        end
      end

    private

      def pending_induction_submission_params
        params.require(:pending_induction_submission).permit(:trn, :date_of_birth)
      end
    end
  end
end
