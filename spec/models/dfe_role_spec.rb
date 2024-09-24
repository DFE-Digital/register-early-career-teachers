require "rails_helper"

RSpec.describe DfERole, type: :model do
  it "defines role precendence" do
    expect(described_class::ROLE_PRECEDENCE).to eq(%w[super_admin finance admin])
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validation' do
    it { is_expected.to allow_value("admin", "super_admin", "finance").for(:role_type) }
    it { is_expected.to validate_presence_of(:user_id).with_message("Choose a user") }
  end
end
