module Authorisable
  extend ActiveSupport::Concern

  included do
    has_many :appropriate_body_roles
    has_many :appropriate_bodies, through: :appropriate_body_roles
    has_many :delivery_partner_roles
    has_many :delivery_partners, through: :delivery_partner_roles
    has_many :lead_provider_roles
    has_many :lead_providers, through: :lead_provider_roles
    has_many :school_roles
    has_many :schools, through: :school_roles
    has_many :dfe_roles
  end

  def can_access?(model)
    return true if dfe_user?
    return AppropriateBodyRole.where(user: self, appropriate_body: model).exists? if model.is_a?(AppropriateBody)
    return DeliveryPartnerRole.where(user: self, delivery_partner: model).exists? if model.is_a?(DeliveryPartner)
    return LeadProviderRole.where(user: self, lead_provider: model).exists? if model.is_a?(LeadProvider)
    return SchoolRole.where(user: self, school: model).exists? if model.is_a?(School)

    false
  end

  def access_type
    return dfe_role_type if dfe_user?
    return :lead_provider if lead_provider_roles.any?
    return :delivery_partner if delivery_partner_roles.any?
    return :appropriate_body if appropriate_body_roles.any?

    :school if school_roles.any?
  end

  def roles
    appropriate_body_roles + delivery_partner_roles + lead_provider_roles + school_roles
  end

  def dfe_user?
    dfe_roles.any?
  end

  def dfe_role_type
    dfe_roles.min_by { |role| DfERole::ROLE_PRECEDENCE.index(role.role_type) }.role_type.to_sym
  end
end
