# frozen_string_literal: true

module Schools
  class TeacherPresenter
    private attr_reader :attributes

    def initialize(attributes = {})
      @attributes = attributes
    end

    def full_name
      first_name = attributes.dig('trs_teacher', 'trs_first_name')
      last_name = attributes.dig('trs_teacher', 'trs_last_name')

      "#{first_name} #{last_name}".strip
    end

    def govuk_date_of_birth
      dob = attributes.dig('trs_teacher', 'date_of_birth')
      dob&.to_date&.to_formatted_s(:govuk)
    end

    def trn
      attributes.dig('trn')
    end

    def email
      attributes.dig('email')
    end

    def national_insurance_number
      attributes.dig('trs_teacher', 'trs_national_insurance_number')
    end
  end
end
