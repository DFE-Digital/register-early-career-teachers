# frozen_string_literal: true

module GIAS
  class Types
    ALL_TYPES = [
      "Community school",
      "Voluntary aided school",
      "Voluntary controlled school",
      "Foundation school",
      "City technology college",
      "Community special school",
      "Non-maintained special school",
      "Other independent special school",
      "Other independent school",
      "Foundation special school",
      "Pupil referral unit",
      "Local authority nursery school",
      "Further education",
      "Secure units",
      "Offshore schools",
      "Service children's education",
      "Miscellaneous",
      "Academy sponsor led",
      "Higher education institutions",
      "Welsh establishment",
      "Sixth form centres",
      "Special post 16 institution",
      "Academy special sponsor led",
      "Academy converter",
      "Free schools",
      "Free schools special",
      "British schools overseas",
      "Free schools alternative provision",
      "Free schools 16 to 19",
      "University technical college",
      "Studio schools",
      "Academy alternative provision converter",
      "Academy alternative provision sponsor led",
      "Academy special converter",
      "Academy 16-19 converter",
      "Academy 16 to 19 sponsor led",
      "Online provider",
      "Institution funded by other government department",
      "Academy secure 16 to 19",
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

    ELIGIBLE_TYPES = ALL_TYPES - [
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

    INDEPENDENT_SCHOOLS_TYPES = [
      "Other independent special school",
      "Other independent school"
    ].freeze
  end
end
