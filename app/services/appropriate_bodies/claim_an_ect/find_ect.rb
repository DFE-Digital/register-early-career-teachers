module AppropriateBodies
  module ClaimAnECT
    class FindECT
      attr_reader :appropriate_body, :pending_induction_submission

      def initialize(appropriate_body:, pending_induction_submission:)
        @appropriate_body = appropriate_body
        @pending_induction_submission = pending_induction_submission
      end
      # def teacher_with_trn_already_exists
      #   # _If an ECT has an open induction period with another AB, then they cannot be claimed until the previous AB tells us they have stopped serving their induction with them.

      #   # In this case, the AB attempting to claim the ECT must be able to easily reference details of the AB associated with the open induction period._
      #   return unless Teacher.exists?(trn:)

      #   errors.add(:trn, "Teacher already exists")
      # end
      def import_from_trs!
        # If an ECT has an open induction period with another AB, then they cannot be claimed until the previous AB tells us they have stopped serving their induction with them.
        # If an ECT has an open induction period with the AB who is trying to claim them, they cannot be claimed again. Show an error message and direct the user towards the ECT’s induction record.
        check_if_teacher_has_active_induction_period!

        # In this case, the AB attempting to claim the ECT must be able to easily reference details of the AB associated with the open induction period._
        # raise if Teacher.exists?(trn: pending_induction_submission.trn)
        # TODO: what do we do if we already have a matching Teacher in
        #       our database as a fully registered teacher?
        #       we probably want a guard clause here or to make the if statement
        #       below a case and add different errors to the :base
        return unless pending_induction_submission.valid?(:find_ect)

        trs_teacher.check_eligibility!

        pending_induction_submission.assign_attributes(appropriate_body:, **trs_teacher.present)
        pending_induction_submission.save(context: :find_ect)
      end

    private

      def trs_teacher
        @trs_teacher ||= api_client.find_teacher(trn: pending_induction_submission.trn, date_of_birth: pending_induction_submission.date_of_birth)
      end

      def api_client
        @api_client ||= TRS::APIClient.new
      end

      def check_if_teacher_has_active_induction_period!
        existing_teacher = Teacher.find_by(trn: pending_induction_submission.trn)

        return unless existing_teacher

        active_induction_period = ::Teachers::ActiveInductionPeriod.new(existing_teacher).active_induction_period

        return unless active_induction_period

        if active_induction_period.appropriate_body == appropriate_body
          raise AppropriateBodies::Errors::TeacherHasActiveInductionPeriodWithABError
        else
          raise AppropriateBodies::Errors::TeacherHasActiveInductionPeriodWithAnotherABError
        end
      end
    end
  end
end
