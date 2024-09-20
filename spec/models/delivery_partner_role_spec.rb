require 'rails_helper'

RSpec.describe DeliveryPartnerRole, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:delivery_partner) }
end
