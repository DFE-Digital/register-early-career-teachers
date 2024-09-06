class Teacher < ApplicationRecord
  # Associations
  has_many :ect_at_school_periods, inverse_of: :teacher
  has_many :mentor_at_school_periods, inverse_of: :teacher

  # Validations
  validates :name,
            presence: true
end
