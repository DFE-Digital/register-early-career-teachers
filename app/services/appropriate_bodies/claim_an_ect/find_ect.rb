module AppropriateBodies
  module ClaimAnECT
    class FindECT
      attr_reader :appropriate_body, :trn, :date_of_birth, :pending_induction_submission

      def initialize(appropriate_body:, pending_induction_submission_params: {})
        @appropriate_body = appropriate_body
        @pending_induction_submission = PendingInductionSubmission.new(**pending_induction_submission_params)
      end

      def import_from_trs
        # TODO: call the TRS API and search for a teacher with matching
        #       TRN and date of birth
        # TODO: what do we do if we already have a matching Teacher in
        #       our database
        #       a) as a fully registered teacher?
        #       b) as another pending induction submission?
        #       we probably want a guard clause here or to make the if statement
        #       below a case and add different errors to the :base

        if (response = find_matching_record_in_trs)
          pending_induction_submission.assign_attributes(appropriate_body:, **response)
        else
          pending_induction_submission.errors.add(:base, "No matching teacher was found")
        end

        pending_induction_submission
      end

    private

      def find_matching_record_in_trs
        # TODO: build query, just fake for now, return false if we find nothing
        #       response is in this format:
        # TODO: the API client should return an object
        # {
        #   "trn": "3001924",
        #   "firstName": "First name",
        #   "middleName": "Middle name",
        #   "lastName": "Last name",
        #   "dateOfBirth": "1990-01-03",
        #   "nationalInsuranceNumber": null,
        #   "emailAddress": null,
        #   "qts": {
        #     "awarded": "2022-07-15",
        #     "certificateUrl": "/v3/certificates/qts",
        #     "statusDescription": "Qualified"
        #   },
        #   "eyts": null
        # }
        # TODO: do we need to do anything with middleName?
        # TODO: we need to store all the details we'll show on the check screen
        #       in the PendingInductionSubmission so we can display it on the
        #       'check' stage

        { trn: "3456345", first_name: "Kirk", last_name: "Van Houten", date_of_birth: Date.new(1970, 1, 1) }
      end
    end
  end
end
