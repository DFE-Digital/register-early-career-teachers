# frozen_string_literal: true

module GIAS
  class Types
    ALL_TYPES = [
      "Academy 16 to 19 sponsor led",
      "Academy 16-19 converter",
      "Academy alternative provision converter",
      "Academy alternative provision sponsor led",
      "Academy converter",
      "Academy secure 16 to 19",
      "Academy special converter",
      "Academy special sponsor led",
      "Academy sponsor led",
      "British schools overseas",
      "City technology college",
      "Community school",
      "Community special school",
      "Foundation school",
      "Foundation special school",
      "Free schools 16 to 19",
      "Free schools alternative provision",
      "Free schools special",
      "Free schools",
      "Further education",
      "Higher education institutions",
      "Institution funded by other government department",
      "Local authority nursery school",
      "Miscellaneous",
      "Non-maintained special school",
      "Offshore schools",
      "Online provider",
      "Other independent school",
      "Other independent special school",
      "Pupil referral unit",
      "Secure units",
      "Service children's education",
      "Sixth form centres",
      "Special post 16 institution",
      "Studio schools",
      "University technical college",
      "Voluntary aided school",
      "Voluntary controlled school",
      "Welsh establishment",
    ].freeze

    CIP_ONLY_TYPES = [
      "Other independent special school",
      "Other independent school",
      "Welsh establishment",
      "British schools overseas"
    ].freeze

    CIP_ONLY_EXCEPT_WELSH = [
      "Other independent special school",
      "Other independent school",
      "British schools overseas"
    ].freeze

    NOT_ELIGIBLE_TYPES = [
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
    ].freeze

    ELIGIBLE_TYPES = ALL_TYPES - NOT_ELIGIBLE_TYPES

    INDEPENDENT_SCHOOLS_TYPES = [
      "Other independent special school",
      "Other independent school"
    ].freeze

    NOT_IN_ENGLAND_TYPES = [
      "British schools overseas",
      "Offshore schools",
      "Service children's education",
      "Welsh establishment",
    ].freeze

    IN_ENGLAND_TYPES = (ALL_TYPES - NOT_IN_ENGLAND_TYPES).freeze
  end
end
