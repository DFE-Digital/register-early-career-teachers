# frozen_string_literal: true

module Schools
  class TeacherPresenter
    def initialize(store)
      @store = store
    end

    delegate :trn, :email, to: :@store

    def full_name
      "#{trs_first_name} #{trs_last_name}".strip
    end

    def govuk_date_of_birth
      trs_date_of_birth.to_date&.to_formatted_s(:govuk)
    end

    def national_insurance_number
      trs_national_insurance_number
    end

    delegate :trs_date_of_birth, to: :@store, private: true
    delegate :trs_national_insurance_number, to: :@store, private: true
    delegate :trs_first_name, to: :@store, private: true
    delegate :trs_last_name, to: :@store, private: true
  end
end
