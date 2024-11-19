# frozen_string_literal: true

module Schools
  module Validation
    class DateOfBirth
      attr_reader :format_error

      # Initializer expects a Hash with the format { 1 => year, 2 => month, 3 => day }

      def initialize(date_of_birth_as_hash)
        @date_of_birth_as_hash = date_of_birth_as_hash
        @format_error = nil
      end

      def valid?
        validate
        format_error.nil?
      end

    private

      attr_reader :date_of_birth_as_hash

      def validate
        return @format_error = "Enter a date of birth" if date_missing?
        return @format_error = "Enter the date of birth in the correct format, for example 12 03 1998" if invalid_date?
        return @format_error = "The teacher cannot be more than 100 years old" if date_of_birth_too_old?
        return @format_error = "The teacher cannot be less than 18 years old" if date_of_birth_too_young?

        true
      end

      def date_missing?
        date_of_birth_as_hash.nil?
      end

      def invalid_date?
        date_of_birth
        false
      rescue ArgumentError
        true
      end

      def date_of_birth
        day = date_of_birth_as_hash[3].to_i
        month = date_of_birth_as_hash[2].to_i
        year = date_of_birth_as_hash[1].to_i

        @date_of_birth ||= Date.new(year, month, day)
      end

      def date_of_birth_too_young?
        date_of_birth > 18.years.ago.to_date
      end

      def date_of_birth_too_old?
        date_of_birth < 100.years.ago.to_date
      end
    end
  end
end
