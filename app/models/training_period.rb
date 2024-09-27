class TrainingPeriod < ApplicationRecord
  include Interval

  # Associations
  belongs_to :ect_at_school_period, class_name: "ECTAtSchoolPeriod", inverse_of: :training_periods
  belongs_to :mentor_at_school_period, inverse_of: :training_periods
  belongs_to :provider_partnership
  has_many :declarations, inverse_of: :training_period

  # Validations
  validates :started_on,
            presence: true

  validates :provider_partnership_id,
            presence: true

  validate :one_id_of_trainee_present
  validate :trainee_distinct_period, if: -> { ect_at_school_period.present? }
  validate :mentor_distinct_period, if: -> { mentor_at_school_period.present? }

  validate :enveloped_by_ect_at_school_period,
           if: -> { ect_at_school_period.present? && started_on.present? }
  validate :enveloped_by_mentor_at_school_period,
           if: -> { mentor_at_school_period.present? && started_on.present? }

  # Scopes
  scope :for_ect, ->(ect_at_school_period_id) { where(ect_at_school_period_id:) }
  scope :for_mentor, ->(mentor_at_school_period_id) { where(mentor_at_school_period_id:) }
  scope :for_provider_partnership, ->(provider_partnership_id) { where(provider_partnership_id:) }
  scope :ect_siblings_of, ->(instance) { for_ect(instance.ect_at_school_period_id).where.not(id: instance.id) }
  scope :mentor_siblings_of, ->(instance) { for_mentor(instance.mentor_at_school_period_id).where.not(id: instance.id) }

  def self.trainee_siblings_of(instance)
    scope = where.not(id: instance.id)
    instance.for_ect? ? scope.ect_siblings_of(instance) : scope.mentor_siblings_of(instance)
  end

  # Instance methods
  def for_ect?
    ect_at_school_period_id.present?
  end

  def for_mentor?
    mentor_at_school_period_id.present?
  end

private

  def one_id_of_trainee_present
    ids = [ect_at_school_period_id, mentor_at_school_period_id]
    errors.add(:base, "Id of trainee missing") if ids.none?
    errors.add(:base, "Only one id of trainee required. Two given") if ids.all?
  end

  def trainee_distinct_period
    overlapping_siblings = TrainingPeriod.trainee_siblings_of(self).overlapping_with(self).exists?
    errors.add(:base, "Trainee periods cannot overlap") if overlapping_siblings
  end

  def mentor_distinct_period
    overlapping_siblings = TrainingPeriod.mentor_siblings_of(self).overlapping_with(self).exists?
    errors.add(:base, "Mentor periods cannot overlap") if overlapping_siblings
  end

  def enveloped_by_ect_at_school_period
    return if (ect_at_school_period.started_on..ect_at_school_period.finished_on).cover?(started_on..finished_on)

    errors.add(:base, "Date range is not contained by the ECT at school period")
  end

  def enveloped_by_mentor_at_school_period
    return if (mentor_at_school_period.started_on..mentor_at_school_period.finished_on).cover?(started_on..finished_on)

    errors.add(:base, "Date range is not contained by the ECT at school period")
  end
end
