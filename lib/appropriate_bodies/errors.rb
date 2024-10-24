module AppropriateBodies
  module Errors
    # class TeacherAlreadyClaimedError < StandardError; end
    class TeacherHasActiveInductionPeriodWithABError < StandardError; end
    class TeacherHasActiveInductionPeriodWithAnotherABError < StandardError; end
  end
end
