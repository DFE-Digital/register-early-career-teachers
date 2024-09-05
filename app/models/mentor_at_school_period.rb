class MentorAtSchoolPeriod < ApplicationRecord
  include Interval

  # Associations
  belongs_to :school, inverse_of: :mentor_at_school_periods
  belongs_to :teacher, inverse_of: :mentor_at_school_periods
  has_many :mentorship_periods, inverse_of: :mentor
  has_many :training_periods, inverse_of: :mentor_at_school_period

  # Validations
  validates :finished_on,
            uniqueness: { scope: %i[teacher_id school_id],
                          message: "matches the end date of an existing period",
                          allow_nil: true }

  validates :started_on,
            presence: true,
            uniqueness: { scope: %i[teacher_id school_id],
                          message: "matches the start date of an existing period" }

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
    overlapping_siblings = self.class.school_siblings_of(self).overlapping(started_on, finished_on).exists?
    errors.add(:base, "Teacher School ECT periods cannot overlap") if overlapping_siblings
  end
end
