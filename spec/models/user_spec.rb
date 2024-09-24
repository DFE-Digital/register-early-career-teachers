require "rails_helper"

describe User do
  subject(:user) { FactoryBot.build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_presence_of(:name) }
end
