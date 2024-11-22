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

      delegate :save!, to: :current_step
      delegate :destroy_session, to: :current_step
    end
  end
end
