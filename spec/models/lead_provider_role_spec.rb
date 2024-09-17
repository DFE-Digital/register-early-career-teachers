require 'rails_helper'

RSpec.describe LeadProviderRole, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:lead_provider) }
end
