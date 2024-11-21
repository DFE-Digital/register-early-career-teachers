# frozen_string_literal: true

module Schools
  module RegisterECT
    class ReviewECTDetailsStep < StoredStep
      def next_step
        :email_address
      end
    end
  end
end
