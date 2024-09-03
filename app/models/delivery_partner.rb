class DeliveryPartner < ApplicationRecord
  # Associations
  has_many :provider_partnerships, inverse_of: :delivery_partner

  # Validations
  validates :name,
            presence: true,
            uniqueness: true
end
