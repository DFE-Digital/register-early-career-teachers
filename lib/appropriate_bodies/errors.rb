module AppropriateBodies
  module Errors
    class TeacherHasActiveInductionPeriodWithCurrentAB < StandardError
      def initialize(full_name)
        msg = "Teacher #{full_name} already has an active induction period with this appropriate body"
        super(msg)
      end
    end

    class TeacherHasActiveInductionPeriodWithAnotherAB < StandardError
      def initialize(full_name)
        msg = "Teacher #{full_name} already has an active induction period with another appropriate body"
        super(msg)
      end
    end
  end
end
