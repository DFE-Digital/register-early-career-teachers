module Interval
  extend ActiveSupport::Concern

  included do
    # Validations
    validate :period_dates_validation

    # Scopes
    scope :overlapping_with, ->(period) { where("range && daterange(?, ?)", period.started_on, period.finished_on) }
  end

  def period_dates_validation
    return if [started_on, finished_on].any?(&:blank?)

    errors.add(:finished_on, "Must be later than :started_on") if finished_on <= started_on
  end
end
