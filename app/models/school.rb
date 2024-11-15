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
  scope :search, ->(q) { includes(:gias_school).merge(GIAS::School.search(q)) }

  # Instance Methods
  delegate :address_line1,
           :address_line2,
           :address_line3,
           :administrative_district_name,
           :closed_on,
           :establishment_number,
           :funding_eligibility,
           :induction_eligibility,
           :in_england,
           :local_authority_code,
           :local_authority_name,
           :name,
           :primary_contact_email,
           :opened_on,
           :phase_name,
           :postcode,
           :type_name,
           :secondary_contact_email,
           :section_41_approved,
           :status,
           :ukprn,
           :website,
           to: :gias_school

  def to_param
    urn
  end
end
