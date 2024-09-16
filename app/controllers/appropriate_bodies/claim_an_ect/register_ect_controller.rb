module AppropriateBodies
  module ClaimAnECT
    class RegisterECTController < AppropriateBodiesController
      def edit
        # FIXME: find within the scope of the current AB

        @pending_induction_submission = PendingInductionSubmission.find(params[:id])
      end

      def update
        @pending_induction_submission = AppropriateBodies::ClaimAnECT::RegisterECT
          .new(appropriate_body: @appropriate_body, pending_induction_submission_id: params[:id])
          .register(update_params)

        if @pending_induction_submission.save(context: :register_ect)
          redirect_to(ab_claim_an_ect_register_path(@pending_induction_submission))
        else
          render(:edit)
        end
      end

      def show
        # FIXME: find within the scope of the current AB

        @pending_induction_submission = PendingInductionSubmission.find(params[:id])
      end

    private

      def update_params
        params.require(:pending_induction_submission).permit(:started_on, :induction_programme)
      end
    end
  end
end
