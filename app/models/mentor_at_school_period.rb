class MentorAtSchoolPeriod < ApplicationRecord
  has_many :mentorship_periods
  has_many :training_periods
  belongs_to :school
  belongs_to :teacher
end
