# frozen_string_literal: true

module Schools
  module RegisterECT
    class NationalInsuranceNumberStep < StoredStep
      attr_accessor :national_insurance_number

      validates :national_insurance_number, national_insurance_number: true

      def self.permitted_params
        %i[national_insurance_number]
      end

      def next_step
        return :not_found unless stored_trs_teacher

        :review_ect_details
      end

      def perform
        store.set("trs_teacher", trs_teacher&.present)
      end

    private

      def stored_trs_teacher
        @stored_trs_teacher ||= store.get("trs_teacher")
      end

      def trn
        stored_trs_teacher&.dig("trn")
      end

      def trs_teacher
        @trs_teacher ||= ::TRS::APIClient.new.find_teacher(trn:, national_insurance_number:)
      end
    end
  end
end
