module AppropriateBodies
  module Teachers
    class RecordPassedOutcomeController < AppropriateBodiesController
      def new
        @teacher = find_teacher

        @pending_induction_submission = PendingInductionSubmission.new
      end

      def create
        @teacher = find_teacher
        @pending_induction_submission = PendingInductionSubmission.new(
          **pending_induction_submission_params,
          **pending_induction_submission_attributes
        )
        record_outcome = AppropriateBodies::RecordOutcome.new(
          appropriate_body: @appropriate_body,
          pending_induction_submission: @pending_induction_submission,
          teacher: @teacher
        )

        PendingInductionSubmission.transaction do
          if @pending_induction_submission.save(context: :record_outcome) && record_outcome.pass!
            redirect_to(
              ab_teacher_record_passed_outcome_path(@teacher),
              flash: { teacher_name: ::Teachers::Name.new(@teacher).full_name }
            )
          else
            render :new
          end
        end
      end

      def show
        @teacher_name = flash['teacher_name']
      end

    private

      def pending_induction_submission_params
        params.require(:pending_induction_submission).permit(:finished_on, :number_of_terms, :outcome)
      end

      def pending_induction_submission_attributes
        { appropriate_body_id: @appropriate_body.id, trn: @teacher.trn, outcome: "pass" }
      end

      def find_teacher
        AppropriateBodies::CurrentTeachers.new(@appropriate_body).current.find_by!(trn: params[:teacher_trn])
      end
    end
  end
end
