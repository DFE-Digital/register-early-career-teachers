class ECTAtSchoolPeriod < ApplicationRecord
  include Interval

  # Associations
  belongs_to :school, inverse_of: :ect_at_school_periods
  belongs_to :teacher, inverse_of: :ect_at_school_periods
  has_many :induction_periods, inverse_of: :ect_at_school_period
  has_many :mentorship_periods, inverse_of: :mentee
  has_many :training_periods, inverse_of: :ect_at_school_period

  # Validations
  validates :finished_on,
            uniqueness: { scope: :teacher_id,
                          allow_nil: true }

  validates :started_on,
            presence: true,
            uniqueness: { scope: :teacher_id }

  validates :school_id,
            presence: true

  validates :teacher_id,
            presence: true

  validate :teacher_distinct_period

  # Scopes
  scope :for_teacher, ->(teacher_id) { where(teacher_id:) }
  scope :siblings_of, ->(instance) { for_teacher(instance.teacher_id).where.not(id: instance.id) }

private

  def teacher_distinct_period
    overlapping_siblings = ECTAtSchoolPeriod.siblings_of(self).overlapping_with(self).exists?
    errors.add(:base, "Teacher ECT periods cannot overlap") if overlapping_siblings
  end
end
