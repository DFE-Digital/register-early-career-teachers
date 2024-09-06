class AppropriateBody < ApplicationRecord
  # Associations
  has_many :induction_periods, inverse_of: :appropriate_body

  # Validations
  validates :name,
            presence: true,
            uniqueness: true
end
