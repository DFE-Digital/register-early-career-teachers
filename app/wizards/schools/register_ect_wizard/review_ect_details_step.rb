# frozen_string_literal: true

module Schools
  module RegisterECTWizard
    class ReviewECTDetailsStep < Step
      attr_accessor :change_name, :corrected_name

      validates :change_name, presence: { message: "Select 'Yes' or 'No' to confirm whether the details are correct" }
      validates :corrected_name, presence: { message: "Enter the full, correct name" }, if: -> { change_name == "yes" }

      def self.permitted_params
        %i[change_name corrected_name]
      end

      def next_step
        :email_address
      end
    end
  end
end
