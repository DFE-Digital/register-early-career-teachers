# frozen_string_literal: true

module Schools
  module RegisterECT
    class FindECTStep < StoredStep
      attr_accessor :trn, :date_of_birth, :national_insurance_number

      validates :trn, teacher_reference_number: true
      validates :date_of_birth, date_of_birth: true

      def self.permitted_params
        %i[trn date_of_birth]
      end

      def next_step
        :review_ect_details
      end
    end
  end
end
