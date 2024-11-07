module TRS
  module Errors
    class TeacherNotFound < StandardError
      def initialize(msg = "No teacher with the provided teacher reference number and date of birth was found")
        super
      end
    end

    class QTSNotAwarded < StandardError
      include Rails.application.routes.url_helpers

      def landing_page_path
        ab_claim_an_ect_find_error_no_qts_path
      end
    end
  end
end
