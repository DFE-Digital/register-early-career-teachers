module AppropriateBodies
  module ClaimAnECT
    class CheckECTController < AppropriateBodiesController
      def edit
        # FIXME: find within the scope of the current AB

        @pending_induction_submission = PendingInductionSubmission.find(params[:id])
      end

      def update
        # FIXME: find within the scope of the current AB
        @pending_induction_submission = PendingInductionSubmission.find(params[:id])

        check_ect = AppropriateBodies::ClaimAnECT::CheckECT
          .new(appropriate_body: @appropriate_body, pending_induction_submission: @pending_induction_submission)

        if check_ect.confirm_info_correct(confirmed?)
          redirect_to(edit_ab_claim_an_ect_register_path(check_ect.pending_induction_submission))
        else
          @pending_induction_submission = check_ect.pending_induction_submission

          render :edit
        end
      end

    private

      def confirmed?
        confirmed_param = params.require("pending_induction_submission").fetch("confirmed")

        ActiveModel::Type::Boolean.new.cast(confirmed_param)
      end
    end
  end
end
