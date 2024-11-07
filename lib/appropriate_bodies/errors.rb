module AppropriateBodies
  module Errors
    class TeacherHasActiveInductionPeriodWithCurrentAB < StandardError
      def initialize(full_name)
        msg = "Teacher #{full_name} already has an active induction period with this appropriate body"
        super(msg)
      end
    end

    class TeacherHasActiveInductionPeriodWithAnotherAB < StandardError
      include Rails.application.routes.url_helpers

      def landing_page_path
        ab_claim_an_ect_find_error_induction_with_another_appropriate_body_path
      end
    end
  end
end
