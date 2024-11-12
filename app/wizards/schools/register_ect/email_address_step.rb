# frozen_string_literal: true

module Schools
  module RegisterECT
    class EmailAddressStep < StoredStep
      attr_accessor :email

      validates :email, presence: { message: "Enter your email address" }, notify_email: true

      def self.permitted_params
        %i[email]
      end

      def next_step
        :check_answers
      end
    end
  end
end
