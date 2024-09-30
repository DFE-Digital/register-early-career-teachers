describe GIAS::SchoolLink do
  describe "db table" do
    it "has name 'gias_school_links'" do
      expect(described_class.table_name).to eq("gias_school_links")
    end
  end

  describe "db columns" do
    it { is_expected.to have_db_column(:link_date).of_type(:date) }
    it { is_expected.to have_db_column(:link_type).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:link_urn).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:urn).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe "db indexes" do
    it { is_expected.to have_db_index(:urn) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:from_gias_school).class_name("GIAS::School").with_primary_key(:urn).with_foreign_key(:urn).inverse_of(:gias_school_links) }
    it { is_expected.to belong_to(:to_gias_school).class_name("GIAS::School").with_primary_key(:urn).with_foreign_key(:link_urn) }
  end

  describe "validations" do
    subject { FactoryBot.create(:gias_school_link) }

    it { is_expected.to validate_inclusion_of(:link_type).in_array(GIAS::SchoolLink::LINK_TYPES) }
    it { is_expected.to validate_presence_of(:link_urn) }
    it { is_expected.to validate_uniqueness_of(:link_urn).scoped_to(:urn) }
    it { is_expected.to validate_numericality_of(:urn).only_integer }
  end
end
