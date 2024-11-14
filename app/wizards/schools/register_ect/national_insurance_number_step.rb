# frozen_string_literal: true

module Schools
  module RegisterECT
    class NationalInsuranceNumberStep < StoredStep
      def self.permitted_params
        %i[national_insurance_number]
      end
    end
  end
end
