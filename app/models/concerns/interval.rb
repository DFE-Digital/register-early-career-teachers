module Interval
  extend ActiveSupport::Concern

  included do
    # Validations
    validate :period_dates_validation

    # Scopes
    scope :extending_later_than, ->(date) { where("finished_on IS NULL OR finished_on > ?", date) }
    scope :starting_earlier_than, ->(date) { where("started_on < ?", date) }
    scope :overlapping_with, ->(period) { where("range && daterange(?, ?)", period.started_on, period.finished_on) }
  end

  def period_dates_validation
    return if [started_on, finished_on].any?(&:blank?)

    errors.add(:finished_on, "Must be later than :started_on") if finished_on <= started_on
  end
end
