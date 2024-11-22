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
        return :not_found unless trs_teacher.trn
        return :national_insurance_number unless birth_date_matches?

        :review_ect_details
      end

      def persist
        store.set("trn", trn)
        store.set("date_of_birth", date_of_birth_string)
        store.set("trs_national_insurance_number", trs_teacher.national_insurance_number)
        store.set("trs_date_of_birth", trs_teacher.date_of_birth)
        store.set("trs_first_name", trs_teacher.first_name)
        store.set("trs_last_name", trs_teacher.last_name)
      end

    private

      def birth_date_matches?
        return false unless trs_teacher.date_of_birth

        trs_teacher.date_of_birth.to_date == date_of_birth_string.to_date
      end

      def date_of_birth_string
        @date_of_birth_string ||= date_of_birth.values.join("-")
      end

      def trs_teacher
        @trs_teacher ||= fetch_trs_teacher(trn:)
      end
    end
  end
end
