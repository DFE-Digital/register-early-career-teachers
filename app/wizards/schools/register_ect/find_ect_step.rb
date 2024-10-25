# frozen_string_literal: true

module Schools
  module RegisterECT
    class FindECTStep < StoredStep
      include ActiveRecord::AttributeAssignment

      attr_accessor :trn, :date_of_birth

      validates :trn, presence: true, format: { with: /\A\d{7}\z/, message: "The TRN must be exactly 7 digits" }

      validates :date_of_birth,
                presence: {
                  message: "Please enter date of birth"
                }

      def self.permitted_params
        %i[trn date_of_birth]
      end

      def next_step
        :review_ect_details
      end
    end
  end
end
