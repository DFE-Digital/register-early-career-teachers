module AppropriateBodies
  class ReleaseECT
    def initialize(appropriate_body:, pending_induction_submission:)
      @appropriate_body = appropriate_body
      @pending_induction_submission = pending_induction_submission
    end

    def release!
      # FIXME: implement a proper release process here,
      #        it probably needs to just close the current
      #        open induction portal and write an event
      true
    end
  end
end
