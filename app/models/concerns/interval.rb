module Interval
  extend ActiveSupport::Concern

  included do
    # Validations
    validate :period_dates_validation

    # Scopes
    scope :overlapping_with, ->(period) { where("range && daterange(?, ?)", period.started_on, period.finished_on) }

    scope :ongoing, -> { where(finished_on: nil) }
  end

  def period_dates_validation
    return if [started_on, finished_on].any?(&:blank?)

    errors.add(:finished_on, "The finish date must be later than the start date") if finished_on <= started_on
  end
end
