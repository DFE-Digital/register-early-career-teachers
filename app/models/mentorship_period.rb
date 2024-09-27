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
  validates :started_on,
            presence: true

  validates :ect_at_school_period_id,
            presence: true

  validates :mentor_at_school_period_id,
            presence: true

  validate :mentee_distinct_period
  validate :enveloped_by_ect_at_school_period, if: -> { mentee.present? && started_on.present? }
  validate :enveloped_by_mentor_at_school_period, if: -> { mentor.present? && started_on.present? }

  # Scopes
  scope :for_mentee, ->(id) { where(ect_at_school_period_id: id) }
  scope :for_mentor, ->(id) { where(mentor_at_school_period_id: id) }
  scope :mentee_siblings_of, ->(instance) { for_mentee(instance.ect_at_school_period_id).where.not(id: instance.id) }

private

  def mentee_distinct_period
    return unless MentorshipPeriod.mentee_siblings_of(self).overlapping_with(self).exists?

    errors.add(:base, "Mentee periods cannot overlap")
  end

  def enveloped_by_ect_at_school_period
    return if (mentee.started_on..mentee.finished_on).cover?(started_on..finished_on)

    errors.add(:base, "Date range is not contained by the ECT at school period")
  end

  def enveloped_by_mentor_at_school_period
    return if (mentor.started_on..mentor.finished_on).cover?(started_on..finished_on)

    errors.add(:base, "Date range is not contained by the mentor at school period")
  end
end
