module Schools
  module RegisterECTWizard
    class ECT < SimpleDelegator
      # This class is a decorator for the SessionRepository
      def full_name
        [trs_first_name, trs_last_name].join(" ").strip
      end

      def govuk_date_of_birth
        trs_date_of_birth.to_date&.to_formatted_s(:govuk)
      end

      def in_trs?
        trs_first_name.present?
      end

      def matches_trs_dob?
        return false if [date_of_birth, trs_date_of_birth].any?(&:blank?)

        trs_date_of_birth.to_date == date_of_birth.to_date
      end

      def induction_completed?
        trs_induction_status == 'Pass'
      end

      def induction_exempt?
        trs_induction_status == 'Exempt'
      end

      def register!
        Schools::RegisterECT.new(first_name: trs_first_name,
                                 last_name: trs_last_name,
                                 trn:,
                                 school_urn:)
                               .register_teacher!
      end
    end
  end
end
