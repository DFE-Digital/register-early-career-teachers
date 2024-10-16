module AppropriateBodies
  module ClaimAnECT
    class FindECTController < AppropriateBodiesController
      def new
        @pending_induction_submission = PendingInductionSubmission.new
      end

      def create
        find_ect = AppropriateBodies::ClaimAnECT::FindECT
          .new(
            appropriate_body: @appropriate_body,
            pending_induction_submission: PendingInductionSubmission.new(
              **pending_induction_submission_params,
              **pending_induction_submission_attributes
            )
          )
        @pending_induction_submission = find_ect.pending_induction_submission

        if find_ect.import_from_trs!
          redirect_to(edit_ab_claim_an_ect_check_path(find_ect.pending_induction_submission))
        else
          render(:new)
        end
      rescue TRS::Errors::TeacherNotFound => e
        @pending_induction_submission.errors.add(:trn, e.message)

        render(:new)
      end

    private

      def pending_induction_submission_params
        params.require(:pending_induction_submission).permit(:trn, :date_of_birth)
      end

      def pending_induction_submission_attributes
        { appropriate_body_id: @appropriate_body.id }
      end
    end
  end
end
