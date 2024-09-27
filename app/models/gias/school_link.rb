class GIAS::SchoolLink < ApplicationRecord
  self.table_name = "gias_school_links"

  LINK_TYPES = [
    "Predecessor - merged",
    "Predecessor",
    "Sixth Form Centre Link",
    "Successor - amalgamated",
    "Successor - merged",
    "Successor",
    "Predecessor - amalgamated",
    "Result of Amalgamation",
    "Merged - expansion in school capacity and changer in age range",
    "Expansion",
    "Other",
    "Merged - expansion of school capacity",
    "Closure",
    "Merged - change in age range",
    "Sixth Form Centre School",
    "Successor - Split School",
    "Predecessor - Split School",
  ].freeze

  # Associations
  belongs_to :from_gias_school, class_name: "GIAS::School", foreign_key: :urn, primary_key: :urn, inverse_of: :gias_school_links
  belongs_to :to_gias_school, class_name: "GIAS::School", foreign_key: :link_urn, primary_key: :urn

  # Validations
  validates :link_type,
            inclusion: { in: LINK_TYPES }

  validates :link_urn,
            presence: true,
            uniqueness: { scope: :urn }

  validates :urn,
            numericality: { only_integer: true }
end
