describe AppropriateBody do
  describe "associations" do
    it { is_expected.to have_many(:induction_periods) }
  end

  describe "validations" do
    subject { build(:appropriate_body) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
