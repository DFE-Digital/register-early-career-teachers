# frozen_string_literal: true

module Schools
  module RegisterECT
    class BaseWizard < DfE::Wizard::Base
      attr_accessor :store, :trn, :date_of_birth, :first_name, :last_name, :national_insurance_number

      steps do
        [
          {
            find_ect: FindECTStep,
            review_ect_details: ReviewECTDetailsStep,
            email_address: EmailAddressStep,
            check_answers: CheckAnswersStep,
            confirmation: ConfirmationStep,
            national_insurance_number: NationalInsuranceNumberStep,
          }
        ]
      end

      delegate :save!, to: :current_step
      delegate :destroy_session, to: :current_step
      delegate :stored_attrs, to: :store
    end
  end
end
