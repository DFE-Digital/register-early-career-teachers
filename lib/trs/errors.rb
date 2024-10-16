module TRS
  module Errors
    class TeacherNotFound < StandardError; end

    class QTSNotAwarded < StandardError
      def initialize(msg = "ECT record found, but QTS has not been awarded")
        super
      end
    end
  end
end
