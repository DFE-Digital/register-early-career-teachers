class MentorshipPeriod < ApplicationRecord
  include Interval

  # Associations
  belongs_to :mentee,
             class_name: "ECTAtSchoolPeriod",
             foreign_key: :ect_at_school_period_id,
             inverse_of: :mentorship_periods

  belongs_to :mentor,
             class_name: "MentorAtSchoolPeriod",
             foreign_key: :mentor_at_school_period_id,
             inverse_of: :mentorship_periods

  # Validations
  validates :finished_on,
            uniqueness: { scope: :ect_at_school_period_id,
                          message: "matches the end date of an existing period for mentee",
                          allow_nil: true }

  validates :started_on,
            presence: true,
            uniqueness: { scope: :ect_at_school_period_id,
                          message: "matches the start date of an existing period for mentee" }

  validates :ect_at_school_period_id,
            presence: true

  validates :mentor_at_school_period_id,
            presence: true

  validate :mentee_distinct_period

  # Scopes
  scope :for_mentee, ->(id) { where(ect_at_school_period_id: id) }
  scope :for_mentor, ->(id) { where(mentor_at_school_period_id: id) }
  scope :mentee_siblings_of, ->(instance) { for_mentee(instance.ect_at_school_period_id).where.not(id: instance.id) }

private

  def mentee_distinct_period
    overlapping_siblings = MentorshipPeriod.mentee_siblings_of(self).overlapping_with(self).exists?
    errors.add(:base, "Mentee periods cannot overlap") if overlapping_siblings
  end
end
