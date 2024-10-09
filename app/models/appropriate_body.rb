class AppropriateBody < ApplicationRecord
  # Associations
  has_many :pending_induction_submissions
  has_many :induction_periods, inverse_of: :appropriate_body
  has_many :appropriate_body_roles
  has_many :users, through: :appropriate_body_roles

  # Validations
  validates :name,
            presence: true,
            uniqueness: true

  validates :local_authority_code,
            presence: { message: 'Enter a local authority code' },
            inclusion: {
              in: 100..999,
              message: 'Must be a number between 100 and 999'
            },
            uniqueness: {
              scope: :establishment_number,
              message: "An appropriate body with this local authority code and establishment number already exists"
            }

  validates :establishment_number,
            presence: { message: 'Enter a establishment number' },
            inclusion: {
              in: 1000..9999,
              message: 'Must be a number between 1000 and 9999'
            }
end
