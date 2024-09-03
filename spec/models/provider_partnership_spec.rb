describe ProviderPartnership do
  describe "associations" do
    it { is_expected.to belong_to(:academic_year).inverse_of(:provider_partnerships) }
    it { is_expected.to belong_to(:lead_provider).inverse_of(:provider_partnerships) }
    it { is_expected.to belong_to(:delivery_partner).inverse_of(:provider_partnerships) }
  end

  describe "validations" do
    subject { create(:provider_partnership) }

    it { is_expected.to validate_presence_of(:academic_year_id) }
    it { is_expected.to validate_presence_of(:lead_provider_id) }
    it { is_expected.to validate_presence_of(:delivery_partner_id) }

    context "uniqueness of academic_year scoped to lead_provider_id and delivery_partner_id" do
      context "when the provider partnership matches the lead_provider_id, delivery_partner_id and academic_year values
               of an existing provider partnership" do
        let!(:existing_partnership) { create(:provider_partnership) }
        let(:academic_year_id) { existing_partnership.academic_year_id }
        let(:lead_provider_id) { existing_partnership.lead_provider_id }
        let(:delivery_partner_id) { existing_partnership.delivery_partner_id }

        subject { build(:provider_partnership, academic_year_id:, lead_provider_id:, delivery_partner_id:) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(academic_year_id: ["has already been added"])
        end
      end
    end

    context "academic_year presence" do
      context "when the academic_year does not exist" do
        subject { build(:provider_partnership, academic_year_id: rand(2021..9999)) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(academic_year_id: ["Academic year not registered"])
        end
      end
    end

    context "lead provider presence" do
      context "when the lead provider does not exist" do
        subject { build(:provider_partnership, lead_provider_id: rand(1000..9999)) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(lead_provider_id: ["Lead provider not registered"])
        end
      end
    end

    context "delivery partner presence" do
      context "when the delivery partner does not exist" do
        subject { build(:provider_partnership, delivery_partner_id: rand(1000..9999)) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(delivery_partner_id: ["Delivery partner not registered"])
        end
      end
    end
  end

  describe "scopes" do
    let!(:ay_1) { create(:academic_year) }
    let!(:ay_2) { create(:academic_year) }
    let!(:lp_1) { create(:lead_provider) }
    let!(:lp_2) { create(:lead_provider) }
    let!(:dp_1) { create(:delivery_partner) }
    let!(:dp_2) { create(:delivery_partner) }
    let!(:partnership_1) { create(:provider_partnership, academic_year: ay_1, lead_provider: lp_1, delivery_partner: dp_1) }
    let!(:partnership_2) { create(:provider_partnership, academic_year: ay_1, lead_provider: lp_1, delivery_partner: dp_2) }
    let!(:partnership_3) { create(:provider_partnership, academic_year: ay_1, lead_provider: lp_2, delivery_partner: dp_1) }
    let!(:partnership_4) { create(:provider_partnership, academic_year: ay_2, lead_provider: lp_1, delivery_partner: dp_2) }

    describe ".for_academic_year" do
      it "returns provider partnerships only for the specified academic year" do
        expect(described_class.for_academic_year(ay_1.id)).to match_array([partnership_1, partnership_2, partnership_3])
      end
    end

    describe ".for_lead_provider" do
      it "returns provider partnerships only for the specified lead provider" do
        expect(described_class.for_lead_provider(lp_2.id)).to match_array([partnership_3])
      end
    end

    describe ".for_delivery_partner" do
      it "returns provider partnerships only for the specified delivery partner" do
        expect(described_class.for_delivery_partner(dp_1.id)).to match_array([partnership_1, partnership_3])
      end
    end
  end
end
