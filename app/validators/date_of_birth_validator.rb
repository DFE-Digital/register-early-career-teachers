class DateOfBirthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    date_of_birth = Schools::Validation::DateOfBirth.new(value)

    unless date_of_birth.valid?
      record.errors.add(attribute, date_of_birth.format_error)
    end
  end
end
