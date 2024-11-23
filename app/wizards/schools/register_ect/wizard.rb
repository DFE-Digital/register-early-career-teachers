# frozen_string_literal: true

module Schools
  module RegisterECT
    class Wizard < DfE::Wizard::Base
      attr_accessor :store

      steps do
        [
          {
            check_answers: CheckAnswersStep,
            confirmation: ConfirmationStep,
            email_address: EmailAddressStep,
            find_ect: FindECTStep,
            national_insurance_number: NationalInsuranceNumberStep,
            not_found: NotFoundStep,
            review_ect_details: ReviewECTDetailsStep,
          }
        ]
      end

      def self.step?(step_name)
        Array(steps).find { |config| config[step_name] }
      end

      delegate :save!, to: :current_step
      delegate :reset, to: :store

      def ect
        @ect ||= ECT.new(store)
      end
    end
  end
end
