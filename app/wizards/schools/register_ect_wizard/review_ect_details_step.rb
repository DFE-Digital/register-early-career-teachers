# frozen_string_literal: true

module Schools
  module RegisterECTWizard
    class ReviewECTDetailsStep < Step
      def next_step
        :email_address
      end
    end
  end
end
