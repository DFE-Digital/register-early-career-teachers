class SchoolRole < ApplicationRecord
  include AliasAssociation

  belongs_to :user
  belongs_to :school
  alias_association :roleable, :school
end
