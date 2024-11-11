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

      def template
        :induction_with_another_appropriate_body
      end
    end
  end
end
