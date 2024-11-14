# frozen_string_literal: true

module Schools
  module RegisterECT
    class NationalInsuranceNumberStep < StoredStep
      attr_accessor :trn, :date_of_birth, :national_insurance_number

      def self.permitted_params
        %i[national_insurance_number]
      end

      def next_step
        :review_ect_details
      end
    end
  end
end
