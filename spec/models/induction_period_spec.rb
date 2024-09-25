describe InductionPeriod do
  describe "associations" do
    it { is_expected.to belong_to(:appropriate_body) }
    it { is_expected.to belong_to(:ect_at_school_period).inverse_of(:induction_periods) }
  end

  describe "validations" do
    subject { FactoryBot.create(:induction_period) }

    it { is_expected.to validate_presence_of(:appropriate_body_id) }
    it { is_expected.to validate_presence_of(:ect_at_school_period_id) }

    describe "teacher distinct period" do
      context "when the period has not finished yet" do
        context "when the ect has a sibling induction period starting later" do
          let!(:existing_period) { FactoryBot.create(:induction_period) }
          let(:ect_at_school_period_id) { existing_period.ect_at_school_period_id }
          let(:started_on) { existing_period.started_on - 1.year }

          subject { FactoryBot.build(:induction_period, ect_at_school_period_id:, started_on:, finished_on: nil) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages).to include(base: ["Teacher induction periods cannot overlap"])
          end
        end
      end

      context "when the period has end date" do
        context "when the ECT has a sibling induction period overlapping" do
          let!(:existing_period) { FactoryBot.create(:induction_period) }
          let(:ect_at_school_period_id) { existing_period.ect_at_school_period_id }
          let(:started_on) { existing_period.finished_on - 1.day }
          let(:finished_on) { started_on + 1.day }

          subject { FactoryBot.build(:induction_period, ect_at_school_period_id:, started_on:, finished_on:) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages).to include(base: ["Teacher induction periods cannot overlap"])
          end
        end
      end
    end

    it { is_expected.to validate_inclusion_of(:induction_programme).in_array(%w[fip cip diy]).with_message("Choose an induction programme") }

    describe "number_of_terms" do
      context "when finished_on is empty" do
        subject { FactoryBot.build(:induction_period, finished_on: nil) }
        it { is_expected.not_to validate_presence_of(:number_of_terms) }
      end

      context "when finished_on is present" do
        subject { FactoryBot.build(:induction_period) }
        it { is_expected.to validate_presence_of(:number_of_terms).with_message("Enter a number of terms") }
      end
    end
  end

  describe "scopes" do
    let!(:ect_at_school_period) { FactoryBot.create(:ect_at_school_period) }
    let!(:appropriate_body) { FactoryBot.create(:appropriate_body) }
    let!(:period_1) { FactoryBot.create(:induction_period, ect_at_school_period:, appropriate_body:, started_on: '2023-01-01', finished_on: '2023-06-01') }
    let!(:period_2) { FactoryBot.create(:induction_period, ect_at_school_period:, started_on: "2023-06-01", finished_on: "2024-01-01") }
    let!(:period_3) { FactoryBot.create(:induction_period, ect_at_school_period:, appropriate_body:, started_on: '2024-01-01', finished_on: nil) }
    let!(:ect_2_period) { FactoryBot.create(:induction_period, appropriate_body:, started_on: '2023-02-01', finished_on: '2023-07-01') }

    describe ".for_ect" do
      it "returns induction periods only for the specified ect at school period" do
        expect(described_class.for_ect(ect_at_school_period.id)).to match_array([period_1, period_2, period_3])
      end
    end

    describe ".for_appropriate_body" do
      it "returns induction periods only for the specified appropriate_body" do
        expect(described_class.for_appropriate_body(appropriate_body.id)).to match_array([period_1, period_3, ect_2_period])
      end
    end

    describe ".siblings_of" do
      let(:induction_period) { FactoryBot.build(:induction_period, ect_at_school_period:, appropriate_body:, started_on: "2022-01-01", finished_on: "2023-01-01") }

      it "returns induction periods only for the specified instance's ect excluding the instance" do
        expect(described_class.siblings_of(induction_period)).to match_array([period_1, period_2, period_3])
      end
    end
  end
end
