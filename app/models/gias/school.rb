class GIAS::School < ApplicationRecord
  self.table_name = "gias_schools"
  self.ignored_columns = %i[search]

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
  validates :establishment_number,
            numericality: { only_integer: true }

  validates :local_authority_code,
            numericality: { only_integer: true }

  validates :name,
            presence: true

  validates :type_name,
            inclusion: {
              in: GIAS::Types::ALL_TYPES,
              message: "is not a valid school type",
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
