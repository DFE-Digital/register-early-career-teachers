class ECTAtSchoolPeriod < ApplicationRecord
  include Interval

  # Associations
  belongs_to :school, inverse_of: :ect_at_school_periods
  belongs_to :teacher, inverse_of: :ect_at_school_periods
  has_many :mentorship_periods, inverse_of: :mentee
  has_many :mentors, through: :mentorship_periods, source: :mentor
  has_many :training_periods, inverse_of: :ect_at_school_period

  has_many :mentor_at_school_periods, through: :teacher

  # Validations
  validates :started_on,
            presence: true

  validates :school_id,
            presence: true

  validates :teacher_id,
            presence: true

  validate :teacher_distinct_period

  # Scopes
  scope :for_teacher, ->(teacher_id) { where(teacher_id:) }
  scope :siblings_of, ->(instance) { for_teacher(instance.teacher_id).where.not(id: instance.id) }

  # Instance methods
  def current_mentorship
    mentorship_periods.ongoing.last
  end

  def current_mentor
    current_mentorship&.mentor
  end

private

  def teacher_distinct_period
    overlapping_siblings = ECTAtSchoolPeriod.siblings_of(self).overlapping_with(self).exists?
    errors.add(:base, "Teacher ECT periods cannot overlap") if overlapping_siblings
  end
end
