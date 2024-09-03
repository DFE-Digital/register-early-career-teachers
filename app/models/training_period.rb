class TrainingPeriod < ApplicationRecord
  include Interval

  # Associations
  belongs_to :trainee, polymorphic: true, inverse_of: :training_periods
  belongs_to :provider_partnership
  has_many :declarations, inverse_of: :training_period

  # Validations
  validates :finished_on,
            uniqueness: { scope: %i[trainee_id trainee_type],
                          message: "matches the end date of an existing period for trainee",
                          allow_nil: true }

  validates :started_on,
            presence: true,
            uniqueness: { scope: %i[trainee_id trainee_type],
                          message: "matches the start date of an existing period for trainee" }

  validates :trainee_id,
            presence: true

  validates :trainee_type,
            presence: true

  validates :provider_partnership_id,
            presence: true

  validate :trainee_presence
  validate :provider_partnership_presence
  validate :trainee_distinct_period

  # Scopes
  scope :for_trainee, ->(trainee_id, trainee_type) { where(trainee_id:, trainee_type:) }
  scope :for_provider_partnership, ->(provider_partnership_id) { where(provider_partnership_id:) }
  scope :trainee_siblings_of, ->(instance) { for_trainee(instance.trainee_id, instance.trainee_type).where.not(id: instance.id) }

private

  def trainee_presence
    errors.add(:trainee_id, "Trainee not registered") if trainee.nil?
  end

  def provider_partnership_presence
    errors.add(:provider_partnership_id, "Provider partnership not registered") if provider_partnership.nil?
  end

  def trainee_distinct_period
    overlapping_siblings = self.class.trainee_siblings_of(self).overlapping(started_on, finished_on).exists?
    errors.add(:base, "Trainee periods cannot overlap") if overlapping_siblings
  end
end
