# frozen_string_literal: true

module Schools
  class TeacherPresenter
    private attr_reader :attributes

    FIND_ECT_STEP = 'find_ect'
    EMAIL_STEP = 'email_address'

    def initialize(attributes = {})
      @attributes = attributes
    end

    def full_name
      first_name = attributes.dig(FIND_ECT_STEP, 'trs_first_name')
      last_name = attributes.dig(FIND_ECT_STEP, 'trs_last_name')

      "#{first_name} #{last_name}".strip
    end

    def govuk_date_of_birth
      dob = attributes.dig(FIND_ECT_STEP, 'date_of_birth')
      dob&.to_date&.to_formatted_s(:govuk)
    end

    def trn
      attributes.dig(FIND_ECT_STEP, 'trn')
    end

    def email
      attributes.dig(EMAIL_STEP, 'trs_email_address')
    end

    def national_insurance_number
      attributes.dig(FIND_ECT_STEP, 'trs_national_insurance_number')
    end
  end
end
