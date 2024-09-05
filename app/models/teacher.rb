class Teacher < ApplicationRecord
  TRN_FORMAT = %r{\A\d{7}\z}

  # Associations
  has_many :ect_at_school_periods, inverse_of: :teacher
  has_many :mentor_at_school_periods, inverse_of: :teacher

  # Validations
  validates :name,
            presence: true

  validates :trn,
            format: { with: TRN_FORMAT, message: "TRN must be 7 numeric digits" },
            uniqueness: { message: 'TRN already exists', case_sensitive: false }
end
