module TRS
  module Errors
    class TeacherNotFound < StandardError; end
    class QTSNotAwarded < StandardError; end
    class ProhibitedFromTeaching < StandardError; end
  end
end
