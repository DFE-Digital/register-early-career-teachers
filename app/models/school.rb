class School < ApplicationRecord
  has_many :ect_at_schools
  belongs_to :gias_school, class_name: "GIAS::School", foreign_key: :urn

  def to_param
    urn
  end
end
