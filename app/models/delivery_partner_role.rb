class DeliveryPartnerRole < ApplicationRecord
  belongs_to :user
  belongs_to :delivery_partner
end
