# frozen_string_literal: true

module Schools
  module RegisterECT
    class BaseWizard < DfE::Wizard::Base
      attr_accessor :store, :trn, :date_of_birth, :first_name, :last_name

      steps do
        [
          {
            find_ect: FindECTStep,
            review_ect_details: ReviewECTDetailsStep
          }
        ]
      end

      delegate :save!, to: :current_step
      delegate :stored_attrs_for, to: :current_step
    end
  end
end
