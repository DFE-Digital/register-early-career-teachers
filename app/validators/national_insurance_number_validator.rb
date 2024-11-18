# frozen_string_literal: true

class NationalInsuranceNumberValidator < ActiveModel::EachValidator
  attr_reader :national_insurance_number

  def validate_each(record, attribute, value)
    @national_insurance_number = Schools::Validation::NationalInsuranceNumber.new(value)
    record.errors.add(attribute, error_message) unless national_insurance_number.valid?
  end

private

  def error_message
    national_insurance_number.error
  end
end
