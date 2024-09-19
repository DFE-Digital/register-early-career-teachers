class LeadProviderRole < ApplicationRecord
  include AliasAssociation

  belongs_to :user
  belongs_to :lead_provider
  alias_association :roleable, :lead_provider
end
