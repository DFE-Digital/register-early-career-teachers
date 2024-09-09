# PendingInductionSubmission will contain data submitted by appropriate bodies
# containing induction information about a ECT.
#
# It is intended to be a short-lived record that we will process, verify and
# eventually write to the actual database before deleting the record here.
class PendingInductionSubmission < ApplicationRecord
  include Interval

  # Associations
  belongs_to :appropriate_body

  # Validations
  validates :trn,
            format: { with: Teacher::TRN_FORMAT, message: "TRN must be 7 numeric digits" }

  validates :establishment_id,
            format: { with: /\A\d{4}\/\d{3}\z/, message: "Enter an establishment ID in the format 1234/567" },
            allow_nil: true

  validates :induction_programme,
            inclusion: { in: %w[fip cip diy],
                         message: "Choose an induction programme" }

  validates :date_of_birth,
            inclusion: { in: 100.years.ago..18.years.ago }

  validates :number_of_terms,
            inclusion: { in: 0..16,
                         message: "Terms must be between 0 and 16" }
end
