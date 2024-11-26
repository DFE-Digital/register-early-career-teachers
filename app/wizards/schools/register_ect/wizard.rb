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
            induction_completed: InductionCompletedStep,
            national_insurance_number: NationalInsuranceNumberStep,
            not_found: NotFoundStep,
            review_ect_details: ReviewECTDetailsStep,
            trn_not_found: TRNNotFoundStep,
          }
        ]
      end

      def self.step?(step_name)
        Array(steps).first[step_name].present?
      end

      delegate :save!, to: :current_step
      delegate :reset, to: :ect

      def ect
        @ect ||= ECT.new(store)
      end
    end
  end
end
