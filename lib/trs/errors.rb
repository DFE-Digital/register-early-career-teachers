module TRS
  module Errors
    class TeacherNotFound < StandardError
      def initialize(msg = "No teacher with the provided teacher reference number and date of birth was found")
        super
      end
    end

    class QTSNotAwarded < StandardError
      include Rails.application.routes.url_helpers

      def template
        :no_qts
      end
    end
  end
end
