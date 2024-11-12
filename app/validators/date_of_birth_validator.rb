# frozen_string_literal: true

class DateOfBirthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      day = value[3].to_i
      month = value[2].to_i
      year = value[1].to_i

      dob = Date.new(year, month, day)
    rescue ArgumentError
      record.errors.add(attribute, "Enter the date of birth in the correct format, for example 12 03 1998")
      return
    end

    if dob < 100.years.ago.to_date
      record.errors.add(attribute, "The teacher cannot be more than 100 years old")
    end

    if dob > 18.years.ago.to_date
      record.errors.add(attribute, "The teacher cannot be less than 18 years old")
    end
  end
end
