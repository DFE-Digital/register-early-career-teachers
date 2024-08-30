class GIAS::School < ApplicationRecord
  self.table_name = "gias_schools"

  has_one :counterpart, class_name: "::School", foreign_key: :urn
end
