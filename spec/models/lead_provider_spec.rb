describe LeadProvider do
  describe "associations" do
    it { is_expected.to have_many(:provider_partnerships) }
  end

  describe "validations" do
    subject { build(:lead_provider) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
