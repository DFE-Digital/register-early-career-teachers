# frozen_string_literal: true

class NationalInsuranceNumberValidator < ActiveModel::EachValidator
  DEFAULT_MESSAGE_SCOPE = "errors.national_insurance_number"

  attr_reader :national_insurance_number

  def validate_each(record, attribute, value)
    @national_insurance_number = NationalInsuranceNumber.new(value)
    record.errors.add(attribute, error_message) unless national_insurance_number.valid?
  end

private

  def error_message
    options[:message] || I18n.t(national_insurance_number.error, scope: message_scope)
  end

  def message_scope
    options[:message_scope] || DEFAULT_MESSAGE_SCOPE
  end
end
