class Teacher < ApplicationRecord
  has_many :ect_at_school_periods
  has_many :mentor_at_school_periods
end
