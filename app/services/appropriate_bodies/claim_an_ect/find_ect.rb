module AppropriateBodies
  module ClaimAnECT
    class FindECT
      attr_reader :appropriate_body, :pending_induction_submission

      def initialize(appropriate_body:, pending_induction_submission:)
        @appropriate_body = appropriate_body
        @pending_induction_submission = pending_induction_submission
      end

      def import_from_trs!
        # TODO: what do we do if we already have a matching Teacher in
        #       our database
        #       a) as a fully registered teacher?
        #       b) as another pending induction submission?
        #       we probably want a guard clause here or to make the if statement
        #       below a case and add different errors to the :base
        return unless pending_induction_submission.valid?(:find_ect)

        pending_induction_submission.assign_attributes(appropriate_body:, **find_matching_record_in_trs)
        pending_induction_submission.save(context: :find_ect)
      end

    private

      def find_matching_record_in_trs
        client = TRS::APIClient.new
        teacher = client.find_teacher(trn: pending_induction_submission.trn, date_of_birth: pending_induction_submission.date_of_birth)

        teacher.present
      end
    end
  end
end
