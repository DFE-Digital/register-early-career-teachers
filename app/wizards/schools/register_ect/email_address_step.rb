# frozen_string_literal: true

module Schools
  module RegisterECT
    class EmailAddressStep < Step
      attr_accessor :email

      validates :email, presence: { message: "Enter the email address" }, notify_email: true

      def self.permitted_params
        %i[email]
      end

      def next_step
        :check_answers
      end
    end
  end
end
