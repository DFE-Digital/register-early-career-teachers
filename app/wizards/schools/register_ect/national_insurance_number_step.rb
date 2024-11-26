# frozen_string_literal: true

module Schools
  module RegisterECT
    class NationalInsuranceNumberStep < Step
      attr_accessor :national_insurance_number

      validates :national_insurance_number, national_insurance_number: true

      def self.permitted_params
        %i[national_insurance_number]
      end

      def next_step
        return :not_found unless ect.in_trs?
        return :induction_completed if ect.induction_completed? && ect.matches_trs_national_insurance_number?
        return :induction_exempt if ect.induction_exempt? && ect.matches_trs_national_insurance_number?

        :review_ect_details
      end

    private

      def persist
        ect.update(national_insurance_number:,
                   trs_national_insurance_number: trs_teacher.national_insurance_number,
                   trs_date_of_birth: trs_teacher.date_of_birth,
                   trs_first_name: trs_teacher.first_name,
                   trs_last_name: trs_teacher.last_name,
                   trs_induction_completed?: trs_teacher.induction_status == 'Pass',
                   trs_induction_exempt?: trs_teacher.induction_status == 'Exempt')
      end

      def trs_teacher
        @trs_teacher ||= fetch_trs_teacher(trn: ect.trn, national_insurance_number:)
      end
    end
  end
end
