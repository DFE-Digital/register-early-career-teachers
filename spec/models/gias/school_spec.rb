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
    it { is_expected.to have_db_column(:administrative_district_code).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:administrative_district_name).of_type(:string) }
    it { is_expected.to have_db_column(:closed_on).of_type(:date) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:easting).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:establishment_number).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:funding_eligibility).of_type(:enum).with_options(null: false) }
    it { is_expected.to have_db_column(:induction_eligibility).of_type(:enum).with_options(null: false) }
    it { is_expected.to have_db_column(:local_authority_code).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:local_authority_name).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:northing).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:opened_on).of_type(:date) }
    it { is_expected.to have_db_column(:phase_code).of_type(:integer).with_options(null: false) }
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
    it { is_expected.to have_db_index(:name).unique }
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
      is_expected.to define_enum_for(:induction_eligibility)
                       .with_values(eligible: "eligible",
                                    ineligible: "ineligible")
                       .backed_by_column_of_type(:enum)
                       .with_prefix(:induction)
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

    it { is_expected.to validate_presence_of(:administrative_district_code) }

    it {
      is_expected.to validate_numericality_of(:easting)
                       .is_greater_than_or_equal_to(0)
                       .is_less_than_or_equal_to(700_000)
                       .with_message("must be between 0 and 700,000")
    }

    it { is_expected.to validate_numericality_of(:local_authority_code).only_integer }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }

    it {
      is_expected.to validate_numericality_of(:northing)
                       .is_greater_than_or_equal_to(0)
                       .is_less_than_or_equal_to(1_300_000)
                       .with_message("must be between 0 and 1,300,000")
    }

    it { is_expected.to validate_numericality_of(:establishment_number).only_integer }

    it {
      is_expected.to validate_inclusion_of(:phase_code)
                       .in_range(0..7)
                       .with_message("must be an integer between 0 and 7")
    }

    it { is_expected.to validate_numericality_of(:type_code).only_integer }

    it {
      is_expected.to validate_inclusion_of(:type_code)
                       .in_array(GIAS::School::ALL_TYPE_CODES)
                       .with_message("is not a valid school type code")
    }

    it { is_expected.to validate_numericality_of(:ukprn).only_integer.allow_nil }
    it { is_expected.to validate_uniqueness_of(:ukprn).allow_nil }
    it { is_expected.to validate_numericality_of(:urn).only_integer }
    it { is_expected.to validate_uniqueness_of(:urn) }
  end

  describe "scopes" do
    describe ".cip_only" do
      subject { described_class.cip_only }

      context "when there are no schools" do
        it { is_expected.to be_blank }
      end

      context "when there are schools with a cip-only type code" do
        let!(:cip_only_schools) { FactoryBot.create_list(:gias_school, 2, :cip_only) }
        let!(:other_schools) { FactoryBot.create_list(:gias_school, 2, :not_cip_only) }

        it { is_expected.to match_array(cip_only_schools) }
      end
    end

    describe ".eligible_for_funding" do
      subject { described_class.eligible_for_funding }

      context "when there are no eligible schools for registration" do
        it { is_expected.to be_blank }
      end

      context "when there are schools not open" do
        let!(:other_school) { FactoryBot.create(:gias_school, :eligible_for_funding, :not_open) }

        it { is_expected.not_to include(other_school) }
      end

      context "when there are schools not in England" do
        let!(:other_school) { FactoryBot.create(:gias_school, :eligible_for_funding, :not_in_england) }

        it { is_expected.not_to include(other_school) }
      end

      context "when there are schools with not eligible type code and not section 41 approved" do
        let!(:other_school) { FactoryBot.create(:gias_school, :eligible_for_funding, :not_eligible_type_code, :not_section_41) }

        it { is_expected.not_to include(other_school) }
      end

      context "when there are schools open, in England and with eligible type code or section 41 approved" do
        let!(:eligible_schools) { FactoryBot.create_list(:gias_school, 2, :eligible_for_funding) }

        it { is_expected.to match_array(eligible_schools) }
      end
    end

    describe ".in_england" do
      subject { described_class.in_england }

      context "when there are no schools" do
        it { is_expected.to be_blank }
      end

      context "when there are schools with administrative district code starting by 'E' or 9999" do
        let!(:english_school_1) { FactoryBot.create(:gias_school, administrative_district_code: "9999") }
        let!(:english_school_2) { FactoryBot.create(:gias_school, administrative_district_code: "E90000001") }
        let!(:other_school) { FactoryBot.create_list(:gias_school, 1, :not_in_england) }

        it { is_expected.to match_array([english_school_1, english_school_2]) }
      end
    end

    describe ".open" do
      subject { described_class.open }

      context "when there are no schools" do
        it { is_expected.to be_blank }
      end

      context "when there are schools with open or proposed_to_close status" do
        let!(:open_school_1) { FactoryBot.create(:gias_school, status: :open) }
        let!(:open_school_2) { FactoryBot.create(:gias_school, status: :proposed_to_close) }
        let!(:other_school) { FactoryBot.create_list(:gias_school, 1, :not_open) }

        it { is_expected.to match_array([open_school_1, open_school_2]) }
      end
    end

    describe ".section_41" do
      subject { described_class.section_41 }

      context "when there are no schools" do
        it { is_expected.to be_blank }
      end

      context "when there are schools with section 41 approved" do
        let!(:section_41_school) { FactoryBot.create(:gias_school, :section_41) }

        before do
          FactoryBot.create_list(:gias_school, 1, :not_section_41)
        end

        it { is_expected.to match_array([section_41_school]) }
      end
    end
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

    describe ".in_england?" do
      context "when the administrative district code is '9999'" do
        subject { FactoryBot.create(:gias_school, administrative_district_code: "9999") }

        it { is_expected.to be_in_england }
      end

      context "when the administrative district code starts by 'E'" do
        subject { FactoryBot.create(:gias_school, administrative_district_code: "E12345678") }

        it { is_expected.to be_in_england }
      end

      context "when the administrative district code doesn't start by 'E' or is '9999'" do
        subject { FactoryBot.create(:gias_school, :not_in_england) }

        it { is_expected.not_to be_in_england }
      end
    end
  end
end
