# frozen_string_literal: true

module Schools
  module RegisterECT
    class FindECTStep < StoredStep
      attr_accessor :trn, :date_of_birth

      validates :trn, presence: {
        message: "Enter a teacher reference number"
      }, format: { with: /\A\d{1,7}\z/, message: "Teacher reference number cannot include more than 7 digits" }

      validates :date_of_birth,
                presence: { message: "Please enter date of birth" },
                date_of_birth: true

      def self.permitted_params
        %i[trn date_of_birth]
      end

      def next_step
        :review_ect_details
      end
    end
  end
end
