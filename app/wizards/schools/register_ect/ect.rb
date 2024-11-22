module Schools
  module RegisterECT
    class ECT < SimpleDelegator
      def full_name
        [trs_first_name, trs_last_name].join(" ").strip
      end

      def govuk_date_of_birth
        trs_date_of_birth.to_date&.to_formatted_s(:govuk)
      end

      def national_insurance_number
        trs_national_insurance_number
      end
    end
  end
end
