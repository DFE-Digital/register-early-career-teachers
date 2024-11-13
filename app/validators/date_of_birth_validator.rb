# frozen_string_literal: true

class DateOfBirthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    date_of_birth = Schools::Validation::DateOfBirth.new(value)

    unless date_of_birth.valid?
      message_scope = "errors.date_of_birth"
      record.errors.add(attribute, I18n.t(date_of_birth.format_error, scope: message_scope))
    end
  end
end
