class MentorAtSchoolPeriod < ApplicationRecord
  include Interval

  # Associations
  belongs_to :school, inverse_of: :mentor_at_school_periods
  belongs_to :teacher, inverse_of: :mentor_at_school_periods
  has_many :mentorship_periods, inverse_of: :mentor
  has_many :training_periods, inverse_of: :mentor_at_school_period

  # Validations
  validates :started_on,
            presence: true

  validates :school_id,
            presence: true

  validates :teacher_id,
            presence: true

  validate :teacher_school_distinct_period

  # Scopes
  scope :for_school, ->(school_id) { where(school_id:) }
  scope :for_teacher, ->(teacher_id) { where(teacher_id:) }
  scope :siblings_of, ->(instance) { for_teacher(instance.teacher_id).where.not(id: instance.id) }
  scope :school_siblings_of, ->(instance) { siblings_of(instance).for_school(instance.school_id) }

private

  def siblings
    self.class.where(teacher_id:).where.not(id:)
  end

  def teacher_school_distinct_period
    overlapping_siblings = MentorAtSchoolPeriod.school_siblings_of(self).overlapping_with(self).exists?
    errors.add(:base, "Teacher School Mentor periods cannot overlap") if overlapping_siblings
  end
end
