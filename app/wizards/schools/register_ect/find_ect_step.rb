# frozen_string_literal: true

module Schools
  module RegisterECT
    class FindECTStep < Step
      attr_accessor :trn, :date_of_birth

      validates :trn, teacher_reference_number: true
      validates :date_of_birth, date_of_birth: true

      def self.permitted_params
        %i[trn date_of_birth]
      end

      def next_step
        return :trn_not_found unless ect.in_trs?
        return :national_insurance_number unless ect.matches_trs_dob?
        return :induction_completed if ect.induction_completed?
        return :induction_exempt if ect.induction_exempt?

        :review_ect_details
      end

    private

      def persist
        ect.update(trn:,
                   date_of_birth: date_of_birth.values.join("-"),
                   trs_date_of_birth: trs_teacher.date_of_birth,
                   trs_trn: trs_teacher.trn,
                   trs_first_name: trs_teacher.first_name,
                   trs_last_name: trs_teacher.last_name,
                   trs_induction_status: trs_teacher.induction_status)
      end

      def trs_teacher
        @trs_teacher ||= fetch_trs_teacher(trn:)
      end
    end
  end
end
