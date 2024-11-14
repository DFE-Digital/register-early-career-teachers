module Schools
  module RegisterECT
    class StepStoreHandlerFactory
      def self.create(step_name:, wizard:, store:, key:)
        case step_name
        when :find_ect
          StoreHandlers::FindECT.new(wizard, store)
        when :national_insurance_number
          StoreHandlers::NationalInsuranceNumber.new(wizard, store)
        when :review_ect_details
          StoreHandlers::ReviewECTDetails.new
        else
          StoreHandlers::Default.new(wizard:, store:, key:)
        end
      end
    end
  end
end
