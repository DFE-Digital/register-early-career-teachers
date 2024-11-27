class InductionPeriod < ApplicationRecord
  include Interval

  # Associations
  belongs_to :appropriate_body
  belongs_to :teacher

  # Validations
  validates :started_on,
            presence: true

  validates :appropriate_body_id,
            presence: true

  validates :number_of_terms,
            presence: { message: "Enter a number of terms",
                        if: -> { finished_on.present? } }

  validates :induction_programme,
            inclusion: { in: %w[fip cip diy],
                         message: "Choose an induction programme" }

  validate :teacher_distinct_period

  validate :number_of_terms_for_ongoing_induction_period

  # Scopes
  scope :for_teacher, ->(teacher) { where(teacher:) }
  scope :for_appropriate_body, ->(appropriate_body) { where(appropriate_body:) }
  scope :siblings_of, ->(instance) { for_teacher(instance.teacher).excluding(instance) }

private

  def teacher_distinct_period
    overlapping_siblings = InductionPeriod.siblings_of(self).overlapping_with(self).exists?

    errors.add(:base, "Induction periods cannot overlap") if overlapping_siblings
  end

  def number_of_terms_for_ongoing_induction_period
    return if finished_on.blank?
    return if number_of_terms.blank?

    if number_of_terms.positive? && number_of_terms < 1
      errors.add(:number_of_terms, "Partial terms can only be recorded after completing a full term of induction. If the early career teacher has done less than one full term of induction they cannot record partial terms and the number inputted should be 0.")
    end
  end
end
