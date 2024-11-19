class InductionExtension < ApplicationRecord
  belongs_to :teacher

  validates :number_of_terms,
            numericality: { in: 0.1...12, message: "Number of terms must between 0.1 and 12.0" }
end
