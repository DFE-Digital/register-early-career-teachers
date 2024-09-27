describe GIAS::School do
  describe "db table" do
    it "has name 'gias_schools'" do
      expect(described_class.table_name).to eq("gias_schools")
    end
  end

  describe "db columns" do
    it { is_expected.to have_db_column(:address_line1).of_type(:string) }
    it { is_expected.to have_db_column(:address_line2).of_type(:string) }
    it { is_expected.to have_db_column(:address_line3).of_type(:string) }
    it { is_expected.to have_db_column(:administrative_district_name).of_type(:string) }
    it { is_expected.to have_db_column(:closed_on).of_type(:date) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:easting).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:establishment_number).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:funding_eligibility).of_type(:enum).with_options(null: false) }
    it { is_expected.to have_db_column(:induction_eligibility).of_type(:boolean).with_options(null: false) }
    it { is_expected.to have_db_column(:in_england).of_type(:boolean).with_options(null: false) }
    it { is_expected.to have_db_column(:local_authority_code).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:local_authority_name).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:northing).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:opened_on).of_type(:date) }
    it { is_expected.to have_db_column(:phase_name).of_type(:string) }
    it { is_expected.to have_db_column(:postcode).of_type(:string) }
    it { is_expected.to have_db_column(:primary_contact_email).of_type(:string) }
    it { is_expected.to have_db_column(:secondary_contact_email).of_type(:string) }
    it { is_expected.to have_db_column(:section_41_approved).of_type(:boolean).with_options(null: false) }
    it { is_expected.to have_db_column(:status).of_type(:enum).with_options(default: "open", null: false) }
    it { is_expected.to have_db_column(:type_code).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:type_name).of_type(:string) }
    it { is_expected.to have_db_column(:ukprn).of_type(:integer) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:urn).of_type(:integer).with_options(primary: true) }
    it { is_expected.to have_db_column(:website).of_type(:string) }
  end

  describe "db indexes" do
    it { is_expected.to have_db_index(:name) }
    it { is_expected.to have_db_index(:ukprn).unique }
  end

  describe "enums" do
    it {
      is_expected.to define_enum_for(:funding_eligibility)
                       .with_values(eligible_for_fip: "eligible_for_fip",
                                    eligible_for_cip: "eligible_for_cip",
                                    ineligible: "ineligible")
                       .backed_by_column_of_type(:enum)
                       .with_prefix(:funding)
                       .validating
    }

    it {
      is_expected.to define_enum_for(:status)
                       .with_values(open: "open",
                                    closed: "closed",
                                    proposed_to_close: "proposed_to_close",
                                    proposed_to_open: "proposed_to_open")
                       .backed_by_column_of_type(:enum)
                       .with_suffix
                       .validating
    }
  end

  describe "associations" do
    it { is_expected.to have_one(:school).with_primary_key(:urn).with_foreign_key(:urn).inverse_of(:gias_school) }
    it { is_expected.to have_many(:gias_school_links).with_foreign_key(:urn).dependent(:destroy).class_name("GIAS::SchoolLink").inverse_of(:from_gias_school) }
  end

  describe "validations" do
    subject { FactoryBot.create(:gias_school) }

    it {
      is_expected.to validate_numericality_of(:easting)
                       .is_greater_than_or_equal_to(0)
                       .is_less_than_or_equal_to(700_000)
                       .with_message("must be between 0 and 700,000")
    }

    it { is_expected.to validate_numericality_of(:local_authority_code).only_integer }
    it { is_expected.to validate_presence_of(:name) }

    it {
      is_expected.to validate_numericality_of(:northing)
                       .is_greater_than_or_equal_to(0)
                       .is_less_than_or_equal_to(1_300_000)
                       .with_message("must be between 0 and 1,300,000")
    }

    it { is_expected.to validate_numericality_of(:establishment_number).only_integer }

    it { is_expected.to validate_numericality_of(:type_code).only_integer }

    it {
      is_expected.to validate_inclusion_of(:type_code)
                       .in_array(GIAS::Types::ALL_TYPE_CODES)
                       .with_message("is not a valid school type code")
    }

    it { is_expected.to validate_numericality_of(:ukprn).only_integer.allow_nil }
    it { is_expected.to validate_uniqueness_of(:ukprn).allow_nil }
    it { is_expected.to validate_numericality_of(:urn).only_integer }
    it { is_expected.to validate_uniqueness_of(:urn) }
  end

  describe "instance methods" do
    describe "#open?" do
      context "when the status is :open" do
        subject { FactoryBot.create(:gias_school, status: :open) }

        it { is_expected.to be_open }
      end

      context "when the status is :proposed_to_close" do
        subject { FactoryBot.create(:gias_school, status: :proposed_to_close) }

        it { is_expected.to be_open }
      end

      context "when the status is not :open or :proposed_to_close" do
        subject { FactoryBot.create(:gias_school, :not_open) }

        it { is_expected.not_to be_open }
      end
    end

    describe "#closed?" do
      context "when the status is :closed" do
        subject { FactoryBot.create(:gias_school, status: :closed) }

        it { is_expected.to be_closed }
      end

      context "when the status is :proposed_to_open" do
        subject { FactoryBot.create(:gias_school, status: :proposed_to_open) }

        it { is_expected.to be_closed }
      end

      context "when the status is not :closed or :proposed_to_open" do
        subject { FactoryBot.create(:gias_school, :open) }

        it { is_expected.not_to be_closed }
      end
    end
  end
end
