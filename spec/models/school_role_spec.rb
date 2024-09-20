require 'rails_helper'

RSpec.describe SchoolRole, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:school) }
end
