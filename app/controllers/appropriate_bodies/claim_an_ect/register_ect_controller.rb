module AppropriateBodies
  module ClaimAnECT
    class RegisterECTController < AppropriateBodiesController
      def edit
        # FIXME: find within the scope of the current AB

        @pending_induction_submission = PendingInductionSubmission.find(params[:id])
      end

      def update
        register_ect = AppropriateBodies::ClaimAnECT::RegisterECT
          .new(
            appropriate_body: @appropriate_body,
            # FIXME: find within the scope of the current AB
            pending_induction_submission: PendingInductionSubmission.find(params[:id])
          )

        if register_ect.register(update_params)
          redirect_to(ab_claim_an_ect_register_path(register_ect.pending_induction_submission))
        else
          @pending_induction_submission = register_ect.pending_induction_submission

          render(:edit)
        end
        # rescue AppropriateBodies::Errors::TeacherAlreadyClaimedError => e
        #   @pending_induction_submission.errors.add(:base, e.message)
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
