RSpec.shared_examples "a uk school" do |key|
  subject { described_class.new }

  describe "scopes" do
    describe ".cip_only" do
      subject { described_class.cip_only }

      context "when there are no schools" do
        it { is_expected.to be_blank }
      end

      context "when there are schools with a cip-only type code" do
        let!(:cip_only_schools) { FactoryBot.create_list(key, 2, :cip_only) }
        let!(:other_schools) { FactoryBot.create_list(key, 2, :not_cip_only) }

        it { is_expected.to match_array(cip_only_schools) }
      end
    end

    describe ".eligible_for_registration" do
      subject { described_class.eligible_for_registration }

      context "when there are no eligible schools for registration" do
        it { is_expected.to be_blank }
      end

      context "when there are schools not open" do
        let!(:other_school) { FactoryBot.create(key, :eligible_for_registration, :not_open) }

        it { is_expected.not_to include(other_school) }
      end

      context "when there are schools not in England" do
        let!(:other_school) { FactoryBot.create(key, :eligible_for_registration, :not_in_england) }

        it { is_expected.not_to include(other_school) }
      end

      context "when there are schools with not eligible type code and not section 41 approved" do
        let!(:other_school) { FactoryBot.create(key, :eligible_for_registration, :not_eligible_type_code, :not_section_41) }

        it { is_expected.not_to include(other_school) }
      end

      context "when there are schools open, in England and with eligible type code or section 41 approved" do
        let!(:eligible_schools) { FactoryBot.create_list(key, 2, :eligible_for_registration) }

        it { is_expected.to match_array(eligible_schools) }
      end
    end

    describe ".in_england" do
      subject { described_class.in_england }

      context "when there are no schools" do
        it { is_expected.to be_blank }
      end

      context "when there are schools with administrative district code starting by 'E' or 9999" do
        let!(:english_school_1) { FactoryBot.create(key, administrative_district_code: "9999") }
        let!(:english_school_2) { FactoryBot.create(key, administrative_district_code: "E90000001") }
        let!(:other_school) { FactoryBot.create_list(key, 1, :not_in_england) }

        it { is_expected.to match_array([english_school_1, english_school_2]) }
      end
    end

    describe ".open" do
      subject { described_class.open }

      context "when there are no schools" do
        it { is_expected.to be_blank }
      end

      context "when there are schools with open or proposed_to_close status" do
        let!(:open_school_1) { FactoryBot.create(key, status: :open) }
        let!(:open_school_2) { FactoryBot.create(key, status: :proposed_to_close) }
        let!(:other_school) { FactoryBot.create_list(key, 1, :not_open) }

        it { is_expected.to match_array([open_school_1, open_school_2]) }
      end
    end

    describe ".section_41" do
      subject { described_class.section_41 }

      context "when there are no schools" do
        it { is_expected.to be_blank }
      end

      context "when there are schools with section 41 approved" do
        let!(:section_41_school) { FactoryBot.create(key, :section_41) }

        before do
          FactoryBot.create_list(key, 1, :not_section_41)
        end

        it { is_expected.to match_array([section_41_school]) }
      end
    end
  end

  describe "instance methods" do
    describe "#open?" do
      context "when the status is :open" do
        subject { FactoryBot.create(key, status: :open) }

        it { is_expected.to be_open }
      end

      context "when the status is :proposed_to_close" do
        subject { FactoryBot.create(key, status: :proposed_to_close) }

        it { is_expected.to be_open }
      end

      context "when the status is not :open or :proposed_to_close" do
        subject { FactoryBot.create(key, :not_open) }

        it { is_expected.not_to be_open }
      end
    end

    describe "#closed?" do
      context "when the status is :closed" do
        subject { FactoryBot.create(key, status: :closed) }

        it { is_expected.to be_closed }
      end

      context "when the status is :proposed_to_open" do
        subject { FactoryBot.create(key, status: :proposed_to_open) }

        it { is_expected.to be_closed }
      end

      context "when the status is not :closed or :proposed_to_open" do
        subject { FactoryBot.create(key, :open) }

        it { is_expected.not_to be_closed }
      end
    end

    describe ".in_england?" do
      context "when the administrative district code is '9999'" do
        subject { FactoryBot.create(key, administrative_district_code: "9999") }

        it { is_expected.to be_in_england }
      end

      context "when the administrative district code starts by 'E'" do
        subject { FactoryBot.create(key, administrative_district_code: "E12345678") }

        it { is_expected.to be_in_england }
      end

      context "when the administrative district code doesn't start by 'E' or is '9999'" do
        subject { FactoryBot.create(key, :not_in_england) }

        it { is_expected.not_to be_in_england }
      end
    end
  end
end
