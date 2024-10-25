class Teacher < ApplicationRecord
  TRN_FORMAT = %r{\A\d{7}\z}

  self.ignored_columns = %i[search]

  # Associations
  has_many :ect_at_school_periods, inverse_of: :teacher
  has_many :mentor_at_school_periods, inverse_of: :teacher
  has_many :induction_periods_reported_by_appropriate_body,
           -> { order(started_on: :asc) },
           class_name: 'InductionPeriod',
           inverse_of: :teacher

  # Validations
  validates :first_name,
            presence: true

  validates :last_name,
            presence: true

  validates :trn,
            format: { with: TRN_FORMAT, message: "TRN must be 7 numeric digits" },
            uniqueness: { message: 'TRN already exists', case_sensitive: false }

  scope :search, ->(query_string) { where('teachers.search @@ websearch_to_tsquery(?)', query_string) }
end
