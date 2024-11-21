# frozen_string_literal: true

module Schools
  module RegisterECT
    class FindECTStep < StoredStep
      attr_accessor :trn, :date_of_birth

      validates :trn, teacher_reference_number: true
      validates :date_of_birth, date_of_birth: true

      def self.permitted_params
        %i[trn date_of_birth]
      end

      def next_step
        return :not_found unless stored_trs_teacher
        return :national_insurance_number unless birth_date_matches?

        :review_ect_details
      end

      def perform
        store.set("trn", trn)
        store.set("date_of_birth", format_date(date_of_birth))
        store.set("trs_teacher", trs_teacher&.present)
      end

    private

      def birth_date_matches?
        return false unless trs_date_of_birth && provided_date_of_birth

        Date.parse(trs_date_of_birth) == Date.parse(provided_date_of_birth)
      end

      def format_date(date_of_birth)
        "#{date_of_birth[1]}/#{date_of_birth[2]}/#{date_of_birth[3]}"
      end

      def provided_date_of_birth
        @provided_date_of_birth ||= store.get("date_of_birth")
      end

      def stored_trs_teacher
        @stored_trs_teacher ||= store.get("trs_teacher")
      end

      def trs_date_of_birth
        @trs_date_of_birth ||= stored_trs_teacher&.dig("date_of_birth")
      end

      def trs_teacher
        @trs_teacher ||= ::TRS::APIClient.new.find_teacher(trn:)
      end
    end
  end
end
