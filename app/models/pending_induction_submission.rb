# PendingInductionSubmission will contain data submitted by appropriate bodies
# containing induction information about a ECT.
#
# It is intended to be a short-lived record that we will process, verify and
# eventually write to the actual database before deleting the record here.
class PendingInductionSubmission < ApplicationRecord
  include Interval

  attribute :confirmed

  enum :outcome, { pass: "pass", fail: "fail" }

  # Associations
  belongs_to :appropriate_body

  # Validations
  validates :appropriate_body_id,
            presence: { message: "Select an appropriate body" }

  validates :trn,
            presence: { message: "Enter a TRN" },
            format: { with: Teacher::TRN_FORMAT, message: "TRN must be 7 numeric digits" },
            on: :find_ect

  validates :establishment_id,
            format: { with: /\A\d{4}\/\d{3}\z/, message: "Enter an establishment ID in the format 1234/567" },
            allow_nil: true

  validates :induction_programme,
            inclusion: { in: %w[fip cip diy],
                         message: "Choose an induction programme" },
            on: :register_ect

  validates :started_on,
            presence: { message: "Enter a start date" },
            on: :register_ect

  validates :finished_on,
            presence: { message: "Enter a finish date" },
            on: %i[release_ect record_outcome]

  validates :number_of_terms,
            inclusion: { in: 0..16,
                         message: "Terms must be between 0 and 16" },
            on: %i[release_ect record_outcome]

  validates :date_of_birth,
            presence: { message: "Enter a date of birth" },
            inclusion: {
              in: 100.years.ago.to_date..18.years.ago.to_date,
              message: "Teacher must be between 18 and 100 years old",
            },
            on: :find_ect

  validates :confirmed,
            acceptance: { message: "Confirm if these details are correct or try your search again" },
            on: :check_ect

  validates :outcome,
            inclusion: {
              in: PendingInductionSubmission.outcomes.keys,
              message: "Outcome must be either 'passed' or 'failed'"
            },
            on: :record_outcome

  validates :trs_qts_awarded,
            presence: { message: "QTS has not been awarded" },
            on: :register_ect

  validate :trs_qts_awarded_before_started_on, on: :register_ect

private

  def trs_qts_awarded_before_started_on
    return unless started_on && trs_qts_awarded

    if trs_qts_awarded > started_on
      errors.add(
        :started_on,
        "Induction start date cannot be earlier than QTS award date (#{trs_qts_awarded.to_fs(:govuk)})"
      )
    end
  end
end
