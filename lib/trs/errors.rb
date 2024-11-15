module TRS
  module Errors
    class TeacherNotFound < StandardError; end
    class QTSNotAwarded < StandardError; end
    class ProhibitedFromTeaching < StandardError; end
    class Exempt < StandardError; end
    class Completed < StandardError; end
  end
end
