class GIAS::School < ApplicationRecord
  include GIAS::Types

  self.table_name = "gias_schools"

  # Enums
  enum :funding_eligibility,
       { eligible_for_fip: "eligible_for_fip",
         eligible_for_cip: "eligible_for_cip",
         ineligible: "ineligible" },
       prefix: :funding,
       validate: true

  enum :induction_eligibility,
       { eligible: "eligible",
         ineligible: "ineligible" },
       prefix: :induction,
       validate: true

  enum :status,
       { open: "open",
         closed: "closed",
         proposed_to_close: "proposed_to_close",
         proposed_to_open: "proposed_to_open" },
       suffix: true,
       validate: true

  # Associations
  has_one :school, foreign_key: :urn, primary_key: :urn, inverse_of: :gias_school
  has_many :gias_school_links, class_name: "GIAS::SchoolLink", foreign_key: :urn, dependent: :destroy, inverse_of: :from_gias_school

  # Validations
  validates :administrative_district_code,
            presence: true

  validates :easting,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 700_000,
              message: "must be between 0 and 700,000",
            }

  validates :establishment_number,
            numericality: { only_integer: true }

  validates :local_authority_code,
            numericality: { only_integer: true }

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :northing,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1_300_000,
              message: "must be between 0 and 1,300,000"
            }

  validates :phase_code,
            numericality: {
              only_integer: true,
              in: 0..7,
              message: "must be an integer between 0 and 7",
            }

  validates :type_code,
            numericality: {
              only_integer: true,
            },
            inclusion: {
              in: ALL_TYPE_CODES,
              message: "is not a valid school type code",
            }

  validates :ukprn,
            numericality: {
              only_integer: true,
              allow_nil: true,
            },
            uniqueness: {
              allow_nil: true,
            }

  validates :urn,
            numericality: {
              only_integer: true,
            },
            uniqueness: true

  # Scopes
  scope :cip_only, -> { open.where(type_code: GIAS::Types::CIP_ONLY_TYPE_CODES) }
  scope :eligible_for_funding, -> { open.in_england.where(type_code: GIAS::Types::ELIGIBLE_TYPE_CODES).or(open.in_england.section_41) }
  scope :in_england, -> { where("administrative_district_code ILIKE 'E%' OR administrative_district_code = '9999'") }
  scope :open, -> { open_status.or(proposed_to_close_status) }
  scope :section_41, -> { where(section_41_approved: true) }

  # Instance Methods
  def closed?
    !open?
  end

  def in_england?
    english_district?(administrative_district_code)
  end

  def open?
    open_status? || proposed_to_close_status?
  end
end
