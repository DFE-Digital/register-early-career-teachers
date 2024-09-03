describe AcademicYear do
  describe "associations" do
    it { is_expected.to have_many(:provider_partnerships) }
  end

  describe "validations" do
    subject { build(:academic_year) }

    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_uniqueness_of(:year) }
    it { is_expected.to validate_numericality_of(:year).only_integer.is_greater_than_or_equal_to(2020) }
  end
end
