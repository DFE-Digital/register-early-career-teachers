# frozen_string_literal: true

module Schools
  module RegisterECT
    class FindECTStep < StoredStep
      include ActiveRecord::AttributeAssignment

      attr_accessor :trn, :date_of_birth

      # validate :trn_validation

      validates :trn, presence: true, teacher_reference_number: true

      validates :date_of_birth,
                presence: {
                  message: "Please enter date of birth"
                }

      def self.permitted_params
        %i[trn date_of_birth]
      end

      def next_step
        :review_ect_details
      end

      # private

      # def trn_validation
      #   teacher_ref_number = TeacherReferenceNumber.new(trn)
      #
      #   unless teacher_ref_number.valid?
      #     message_scope = "errors.teacher_reference_number"
      #     errors.add(:trn, I18n.t(teacher_ref_number.format_error, scope: message_scope))
      #   end
      # end
    end
  end
end
