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
        return :not_found unless trs_teacher.first_name

        :review_ect_details
      end

      def persist
        store.set("national_insurance_number", national_insurance_number)
        store.set("trs_national_insurance_number", trs_teacher.national_insurance_number)
        store.set("trs_date_of_birth", trs_teacher.date_of_birth)
        store.set("trs_first_name", trs_teacher.first_name)
        store.set("trs_last_name", trs_teacher.last_name)
      end

    private

      delegate :trn, to: :store, private: true

      def trs_teacher
        @trs_teacher ||= fetch_trs_teacher(trn:, national_insurance_number:)
      end
    end
  end
end
