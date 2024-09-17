require "rails_helper"

RSpec.describe DfERole, type: :model do
  it { should belong_to(:user) }
  it { is_expected.to allow_value("admin", "super_admin", "finance").for(:role_type) }

  it "defines role precendence" do
    expect(described_class::ROLE_PRECEDENCE).to eq(%w[super_admin finance admin])
  end
end
