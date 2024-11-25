module AppropriateBodies
  module ClaimAnECT
    class RegisterECTController < AppropriateBodiesController
      def edit
        @pending_induction_submission = find_pending_induction_submission
      end

      def update
        register_ect = AppropriateBodies::ClaimAnECT::RegisterECT
          .new(
            appropriate_body: @appropriate_body,
            pending_induction_submission: find_pending_induction_submission
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
        @pending_induction_submission = find_pending_induction_submission
      end

    private

      def update_params
        params.require(:pending_induction_submission).permit(:started_on, :induction_programme)
      end

      def find_pending_induction_submission
        PendingInductionSubmissions::Search.new(appropriate_body: @appropriate_body).pending_induction_submissions.find(params[:id])
      end
    end
  end
end
