module Interval
  extend ActiveSupport::Concern

  included do
    # Validations
    validate :period_dates_validation

    # Scopes
    scope :extending_later_than, ->(date) { where("finished_on IS NULL OR finished_on > ?", date) }
    scope :starting_earlier_than, ->(date) { where("started_on < ?", date) }
  end

  def period_dates_validation
    return if [started_on, finished_on].any?(&:blank?)

    errors.add(:finished_on, "Must be later than :started_on") if finished_on <= started_on
  end

  class_methods do
    def overlapping(start_date, end_date)
      scope = extending_later_than(start_date)
      end_date ? scope.starting_earlier_than(end_date) : scope
    end
  end
end
