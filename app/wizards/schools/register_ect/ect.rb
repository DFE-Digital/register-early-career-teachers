module Schools
  module RegisterECT
    class ECT
      delegate :reset, :update, :email, :date_of_birth, :trn, :national_insurance_number, :trs_national_insurance_number, :trs_induction_completed?, :trs_first_name, :trs_last_name, :trs_date_of_birth, :trs_induction_status, :date_of_birth, to: :session_repository
      delegate :create!, to: :teacher_repository

      def initialize(session_repository:, teacher_repository:)
        @session_repository = session_repository
        @teacher_repository = teacher_repository
      end

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

      def create_teacher!
        create!(trs_first_name:, trs_last_name:, trn:)
      end

    private

      attr_reader :session_repository, :teacher_repository
    end
  end
end
