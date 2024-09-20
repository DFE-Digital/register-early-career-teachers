require 'rails_helper'

RSpec.describe AppropriateBodyRole, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:appropriate_body) }
end
