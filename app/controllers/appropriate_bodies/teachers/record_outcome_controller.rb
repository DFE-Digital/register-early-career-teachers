module AppropriateBodies
  module Teachers
    class RecordOutcomeController < AppropriateBodiesController
      def new
        @teacher = Teacher.find(params[:ab_teacher_id])

        @pending_induction_submission = PendingInductionSubmission.new
      end

      def create
        @teacher = Teacher.find(params[:ab_teacher_id])
        @pending_induction_submission = PendingInductionSubmission.new(
          **pending_induction_submission_params,
          **pending_induction_submission_attributes
        )

        record_outcome = AppropriateBodies::RecordOutcome.new(appropriate_body: @appropriate_body, pending_induction_submission: @pending_induction_submission)

        PendingInductionSubmission.transaction do
          if @pending_induction_submission.save(context: :record_outcome) && record_outcome.record_outcome!
            redirect_to ab_teacher_record_outcome_path(@teacher)
          else
            render :new
          end
        end
      end

      def show
        @teacher = Teacher.find(params[:ab_teacher_id])
      end

    private

      def pending_induction_submission_params
        params.require(:pending_induction_submission).permit(:finished_on, :number_of_terms, :outcome)
      end

      def pending_induction_submission_attributes
        { appropriate_body_id: @appropriate_body.id, trn: @teacher.trn }
      end
    end
  end
end
