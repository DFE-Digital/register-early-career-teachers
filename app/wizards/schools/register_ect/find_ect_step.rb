# frozen_string_literal: true

module Schools
  module RegisterECT
    class FindECTStep < StoredStep
      attr_accessor :trn, :date_of_birth

      validates :trn, presence: { message: "Enter a teacher reference number" },
                      teacher_reference_number: true

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
