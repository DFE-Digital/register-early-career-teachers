class DeliveryPartnerRole < ApplicationRecord
  include AliasAssociation

  belongs_to :user
  belongs_to :delivery_partner
  alias_association :roleable, :delivery_partner
end
