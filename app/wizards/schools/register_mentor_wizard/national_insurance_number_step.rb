# frozen_string_literal: true

module Schools
  module RegisterMentorWizard
    class NationalInsuranceNumberStep < Step
      attr_accessor :national_insurance_number

      validates :national_insurance_number, national_insurance_number: true

      def self.permitted_params
        %i[national_insurance_number]
      end

      def next_step
        return :not_found unless mentor.in_trs?

        :review_mentor_details
      end

    private

      def persist
        mentor.update(national_insurance_number:,
                      trs_first_name: trs_teacher.first_name,
                      trs_last_name: trs_teacher.last_name)
      end

      def trs_teacher
        @trs_teacher ||= fetch_trs_teacher(trn: mentor.trn, national_insurance_number:)
      end
    end
  end
end
