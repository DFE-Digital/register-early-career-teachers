class InductionPeriod < ApplicationRecord
  include Interval

  # Associations
  belongs_to :appropriate_body
  belongs_to :ect_at_school_period, class_name: "ECTAtSchoolPeriod", inverse_of: :induction_periods

  # Validations
  validates :started_on,
            presence: true

  validates :appropriate_body_id,
            presence: true

  validates :ect_at_school_period_id,
            presence: true

  validates :number_of_terms,
            presence: { message: "Enter a number of terms",
                        if: -> { finished_on.present? } }

  validates :induction_programme,
            inclusion: { in: %w[fip cip diy],
                         message: "Choose an induction programme" }

  validate :teacher_distinct_period
  validate :enveloped_by_ect_at_school_period,
           if: -> { ect_at_school_period.present? && started_on.present? }

  # Scopes
  scope :for_ect, ->(ect_at_school_period_id) { where(ect_at_school_period_id:) }
  scope :for_appropriate_body, ->(appropriate_body_id) { where(appropriate_body_id:) }
  scope :siblings_of, ->(instance) { for_ect(instance.ect_at_school_period_id).where.not(id: instance.id) }

private

  def teacher_distinct_period
    overlapping_siblings = InductionPeriod.siblings_of(self).overlapping_with(self).exists?
    errors.add(:base, "Teacher induction periods cannot overlap") if overlapping_siblings
  end

  def enveloped_by_ect_at_school_period
    return if (ect_at_school_period.started_on..ect_at_school_period.finished_on).cover?(started_on..finished_on)

    errors.add(:base, "Date range is not contained by the ECT at school period")
  end
end
