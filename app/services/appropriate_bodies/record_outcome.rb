module AppropriateBodies
  class RecordOutcome
    def initialize(appropriate_body:, pending_induction_submission:)
      @appropriate_body = appropriate_body
      @pending_induction_submission = pending_induction_submission
    end

    def record_outcome!
      # FIXME: implement a proper release process here,
      #        it needs to close the open inductoin
      #        period and send an update to TRS with the
      #        outcome and finish date

      true
    end
  end
end
