class MentorshipPeriod < ApplicationRecord
  belongs_to :mentee,
             class_name: "ECTAtSchoolPeriod",
             foreign_key: "ect_at_school_period_id"
  belongs_to :mentor,
             class_name: "MentorAtSchoolPeriod",
             foreign_key: "mentor_at_school_period_id"
end
