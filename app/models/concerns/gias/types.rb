# frozen_string_literal: true

module GIAS
  module Types
    extend ActiveSupport::Concern

    ALL_TYPES = {
      "Community school" => 1,
      "Voluntary aided school" => 2,
      "Voluntary controlled school" => 3,
      "Foundation school" => 5,
      "City technology college" => 6,
      "Community special school" => 7,
      "Non-maintained special school" => 8,
      "Other independent special school" => 10,
      "Other independent school" => 11,
      "Foundation special school" => 12,
      "Pupil referral unit" => 14,
      "Local authority nursery school" => 15,
      "Further education" => 18,
      "Secure units" => 24,
      "Offshore schools" => 25,
      "Service children's education" => 26,
      "Miscellaneous" => 27,
      "Academy sponsor led" => 28,
      "Higher education institutions" => 29,
      "Welsh establishment" => 30,
      "Sixth form centres" => 31,
      "Special post 16 institution" => 32,
      "Academy special sponsor led" => 33,
      "Academy converter" => 34,
      "Free schools" => 35,
      "Free schools special" => 36,
      "British schools overseas" => 37,
      "Free schools alternative provision" => 38,
      "Free schools 16 to 19" => 39,
      "University technical college" => 40,
      "Studio schools" => 41,
      "Academy alternative provision converter" => 42,
      "Academy alternative provision sponsor led" => 43,
      "Academy special converter" => 44,
      "Academy 16-19 converter" => 45,
      "Academy 16 to 19 sponsor led" => 46,
      "Online provider" => 49,
      "Institution funded by other government department" => 56,
      "Academy secure 16 to 19" => 57,
    }.freeze

    ALL_TYPE_CODES = ALL_TYPES.values.freeze

    CIP_ONLY_TYPE_CODES = ALL_TYPES.values_at(
      "Other independent special school",
      "Other independent school",
      "Welsh establishment",
      "British schools overseas"
    ).freeze

    CIP_ONLY_EXCEPT_WELSH_CODES = ALL_TYPES.values_at(
      "Other independent special school",
      "Other independent school",
      "British schools overseas"
    ).freeze

    ELIGIBLE_TYPE_CODES = ALL_TYPES.except(
      "Other independent special school",
      "Other independent school",
      "Secure units",
      "Offshore schools",
      "Service children's education",
      "Miscellaneous",
      "Higher education institutions",
      "Welsh establishment",
      "British schools overseas",
      "Online provider",
      "Institution funded by other government department"
    ).values.freeze

    INDEPENDENT_SCHOOLS_TYPE_CODES = ALL_TYPES.values_at(
      "Other independent special school",
      "Other independent school"
    ).freeze

  private

    def cip_only_type?(type_code)
      CIP_ONLY_EXCEPT_WELSH_CODES.include?(type_code)
    end

    def eligible_type?(type_code)
      ELIGIBLE_TYPE_CODES.include?(type_code)
    end

    class_methods do
      def type_code_for(name)
        ALL_TYPES[name]
      end

      def type_name_for(code)
        ALL_TYPES.key(code)
      end
    end
  end
end
