module AppropriateBodies
  module ClaimAnECT
    class FindECTController < AppropriateBodiesController
      def new
        @pending_induction_submission = PendingInductionSubmission.new
      end

      def create
        @pending_induction_submission = PendingInductionSubmission.new(
          **pending_induction_submission_params,
          **pending_induction_submission_attributes
        )

        AppropriateBodies::ClaimAnECT::FindECT
          .new(appropriate_body: @appropriate_body, pending_induction_submission: @pending_induction_submission)
          .import_from_trs

        if @pending_induction_submission.save(context: :find_ect)
          redirect_to(edit_ab_claim_an_ect_check_path(@pending_induction_submission))
        else
          render(:new)
        end
      rescue TRS::Errors::TeacherNotFound => e
        @pending_induction_submission.errors.add(:base, e.message)

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
