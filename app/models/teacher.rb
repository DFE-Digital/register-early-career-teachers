class Teacher < ApplicationRecord
  TRN_FORMAT = %r{\A\d{7}\z}

  self.ignored_columns = %i[search]

  # Associations
  has_many :ect_at_school_periods, inverse_of: :teacher
  has_many :mentor_at_school_periods, inverse_of: :teacher
  has_many :induction_extensions, inverse_of: :teacher
  has_many :induction_periods, -> { order(started_on: :asc) }

  # Validations
  validates :first_name,
            presence: true

  validates :last_name,
            presence: true

  validates :trn,
            uniqueness: { message: 'TRN already exists', case_sensitive: false },
            teacher_reference_number: true

  # Scopes
  scope :search, ->(query_string) { where("teachers.search @@ websearch_to_tsquery('unaccented', ?)", query_string) }

  def to_param
    trn
  end
end
