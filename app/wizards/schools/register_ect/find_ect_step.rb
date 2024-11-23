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
        return :not_found unless ect.in_trs?
        return :national_insurance_number unless ect.matches_trs_dob?

        :review_ect_details
      end

      def persist
        ect.update(trn:,
                   date_of_birth: date_of_birth.values.join("-"),
                   trs_national_insurance_number: trs_teacher.national_insurance_number,
                   trs_date_of_birth: trs_teacher.date_of_birth,
                   trs_first_name: trs_teacher.first_name,
                   trs_last_name: trs_teacher.last_name)
      end

    private

      def trs_teacher
        @trs_teacher ||= fetch_trs_teacher(trn:)
      end
    end
  end
end
