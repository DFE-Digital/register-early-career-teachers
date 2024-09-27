class GIAS::School < ApplicationRecord
  self.table_name = "gias_schools"

  # Enums
  enum :funding_eligibility,
       { eligible_for_fip: "eligible_for_fip",
         eligible_for_cip: "eligible_for_cip",
         ineligible: "ineligible" },
       prefix: :funding,
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
            presence: true

  validates :northing,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1_300_000,
              message: "must be between 0 and 1,300,000"
            }

  validates :type_code,
            numericality: {
              only_integer: true,
            },
            inclusion: {
              in: GIAS::Types::ALL_TYPE_CODES,
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

  # Instance Methods
  def closed?
    !open?
  end

  def open?
    open_status? || proposed_to_close_status?
  end
end
