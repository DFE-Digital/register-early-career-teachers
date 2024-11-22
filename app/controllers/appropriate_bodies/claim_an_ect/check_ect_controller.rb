module AppropriateBodies
  module ClaimAnECT
    class CheckECTController < AppropriateBodiesController
      def edit
        @pending_induction_submission = find_pending_induction_submission
      end

      def update
        @pending_induction_submission = find_pending_induction_submission

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

      def find_pending_induction_submission
        PendingInductionSubmissions::Search.new(appropriate_body: @appropriate_body).pending_induction_submissions.find(params[:id])
      end
    end
  end
end
