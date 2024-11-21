# frozen_string_literal: true

module Schools
  module RegisterECT
    class BaseWizard < DfE::Wizard::Base
      attr_accessor :store, :trn, :date_of_birth, :first_name, :last_name, :national_insurance_number

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
      delegate :stored_attrs, to: :store
    end
  end
end
