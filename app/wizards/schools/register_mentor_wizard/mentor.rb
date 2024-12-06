# Steps in Schools::RegisterMentorWizard will have a Schools::RegisterMentor::Mentor instance
# available rather than the wizard store directly.
# The aim of this class is to encapsulate and provide Mentor logic instead of spreading it througoutht the various steps.
#
# This class will depend so much on the multiple data saved in the wizard.store by the steps during the journey
# that has been built on top of it by inheriting from Ruby SimpleDelegator class.
module Schools
  module RegisterMentorWizard
    class Mentor < SimpleDelegator
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

      def register!
        Schools::RegisterMentor.new(first_name: trs_first_name,
                                    last_name: trs_last_name,
                                    trn:,
                                    school_urn:)
                               .register_mentor!
      end

    private

      # The wizard store object where we delegate the rest of methods
      def wizard_store
        __getobj__
      end
    end
  end
end
