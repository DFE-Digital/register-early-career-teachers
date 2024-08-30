class GIAS::School < ApplicationRecord
  has_one :counterpart, class_name: "::School", foreign_key: :urn
end
