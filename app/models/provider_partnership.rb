class ProviderPartnership < ApplicationRecord
  # Associations
  belongs_to :academic_year, inverse_of: :provider_partnerships
  belongs_to :lead_provider, inverse_of: :provider_partnerships
  belongs_to :delivery_partner, inverse_of: :provider_partnerships

  # Validations
  validates :academic_year_id,
            presence: true,
            uniqueness: { scope: %i[lead_provider_id delivery_partner_id],
                          message: "has already been added" }

  validates :lead_provider_id,
            presence: true

  validates :delivery_partner_id,
            presence: true

  validate :academic_year_presence
  validate :lead_provider_presence
  validate :delivery_partner_presence

  # Scopes
  scope :for_academic_year, ->(year) { where(academic_year_id: year) }
  scope :for_lead_provider, ->(lead_provider_id) { where(lead_provider_id:) }
  scope :for_delivery_partner, ->(delivery_partner_id) { where(delivery_partner_id:) }

private

  def academic_year_presence
    errors.add(:academic_year_id, "Academic year not registered") if academic_year.nil?
  end

  def delivery_partner_presence
    errors.add(:delivery_partner_id, "Delivery partner not registered") if delivery_partner.nil?
  end

  def lead_provider_presence
    errors.add(:lead_provider_id, "Lead provider not registered") if lead_provider.nil?
  end
end
