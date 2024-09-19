class AppropriateBodyRole < ApplicationRecord
  include AliasAssociation

  belongs_to :user
  belongs_to :appropriate_body
  alias_association :roleable, :appropriate_body
end
