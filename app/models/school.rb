class School < ApplicationRecord
  # Associations
  belongs_to :gias_school, class_name: "GIAS::School", foreign_key: :urn, inverse_of: :school
  has_many :ect_at_school_periods, inverse_of: :school
  has_many :mentor_at_school_periods, inverse_of: :school

  # Validations
  validates :urn,
            presence: true,
            uniqueness: true

  # Scopes
  scope :search, ->(q) { includes(:gias_school).references(:gias_schools).where("gias_schools.search @@ websearch_to_tsquery('unaccented', ?)", q) }

  # Instance Methods
  delegate :address_line1, :address_line2, :address_line3, to: :gias_school
  delegate :administrative_district_name, :closed_on, :establishment_number, to: :gias_school
  delegate :funding_eligibility, :induction_eligibility, :in_england, to: :gias_school
  delegate :local_authority_code, :local_authority_name, to: :gias_school
  delegate :name, :primary_contact_email, to: :gias_school
  delegate :opened_on, :phase_name, :postcode, :type_name, to: :gias_school
  delegate :secondary_contact_email, :section_41_approved, :status, to: :gias_school
  delegate :ukprn, :website, to: :gias_school

  def to_param
    urn
  end
end
