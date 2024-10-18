module TRS
  module Errors
    class TeacherNotFound < StandardError
      def initialize(msg = "No teacher with the provided teacher reference number and date of birth was found")
        super
      end
    end

    class QTSNotAwarded < StandardError
      def initialize(msg = "ECT record found, but QTS has not been awarded")
        super
      end
    end
  end
end
