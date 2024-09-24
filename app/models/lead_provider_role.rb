class LeadProviderRole < ApplicationRecord
  belongs_to :user
  belongs_to :lead_provider
end
