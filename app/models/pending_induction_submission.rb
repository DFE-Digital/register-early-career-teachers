# PendingInductionSubmission will contain data submitted by appropriate bodies
# containing induction information about a ECT.
#
# It is intended to be a short-lived record that we will process, verify and
# eventually write to the actual database before deleting the record here.
class PendingInductionSubmission < ApplicationRecord
  include Interval

  attribute :confirmed

  # Associations
  belongs_to :appropriate_body

  # Validations
  validates :trn,
            presence: { message: "Enter a TRN" },
            format: { with: Teacher::TRN_FORMAT, message: "TRN must be 7 numeric digits" }

  validates :establishment_id,
            format: { with: /\A\d{4}\/\d{3}\z/, message: "Enter an establishment ID in the format 1234/567" },
            allow_nil: true

  validates :induction_programme,
            inclusion: { in: %w[fip cip diy],
                         message: "Choose an induction programme" },
            on: :record_period

  validates :date_of_birth,
            presence: { message: "Enter a date of birth" },
            inclusion: {
              in: 100.years.ago.to_date..18.years.ago.to_date,
              message: "Teacher must be between 18 and 100 years old",
            }

  validates :number_of_terms,
            inclusion: { in: 0..16,
                         message: "Terms must be between 0 and 16" },
            on: :record_period

  validates :confirmed,
            acceptance: { message: "Confirm if these details are correct or try your search again" },
            on: :confirming_ect
end
