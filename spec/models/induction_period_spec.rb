describe InductionPeriod do
  describe "associations" do
    it { is_expected.to belong_to(:appropriate_body) }
    it { is_expected.to belong_to(:ect_at_school_period).inverse_of(:induction_periods) }
  end

  describe "validations" do
    subject { create(:induction_period) }

    it {
      is_expected.to validate_uniqueness_of(:finished_on)
                          .scoped_to(:ect_at_school_period_id)
                          .allow_nil
                          .with_message("matches the end date of an existing period for ECT")
    }

    it {
      is_expected.to validate_uniqueness_of(:started_on)
                          .scoped_to(:ect_at_school_period_id)
                          .with_message("matches the start date of an existing period for ECT")
    }
    it { is_expected.to validate_presence_of(:appropriate_body_id) }
    it { is_expected.to validate_presence_of(:ect_at_school_period_id) }

    context "appropriate body presence" do
      context "when the appropriate body does not exist" do
        subject { build(:induction_period, appropriate_body_id: rand(1000..9999)) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(appropriate_body_id: ["Appropriate body not registered"])
        end
      end
    end

    context "ect_at_school_period presence" do
      context "when the ect_at_school_period does not exist" do
        subject { build(:induction_period, ect_at_school_period_id: rand(1000..9999)) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(ect_at_school_period_id: ["ECT period not registered"])
        end
      end
    end

    context "teacher distinct period" do
      context "when the period has not finished yet" do
        context "when the ect has a sibling induction period starting later" do
          let!(:existing_period) { create(:induction_period) }
          let(:ect_at_school_period_id) { existing_period.ect_at_school_period_id }
          let(:started_on) { existing_period.started_on - 1.year }

          subject { build(:induction_period, ect_at_school_period_id:, started_on:, finished_on: nil) }

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
          let!(:existing_period) { create(:induction_period) }
          let(:ect_at_school_period_id) { existing_period.ect_at_school_period_id }
          let(:started_on) { existing_period.finished_on - 1.day }
          let(:finished_on) { started_on + 1.day }

          subject { build(:induction_period, ect_at_school_period_id:, started_on:, finished_on:) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages).to include(base: ["Teacher induction periods cannot overlap"])
          end
        end
      end
    end
  end

  describe "scopes" do
    let!(:ect_at_school_period) { create(:ect_at_school_period) }
    let!(:appropriate_body) { create(:appropriate_body) }
    let!(:period_1) { create(:induction_period, ect_at_school_period:, appropriate_body:, started_on: '2023-01-01', finished_on: '2023-06-01') }
    let!(:period_2) { create(:induction_period, ect_at_school_period:, started_on: "2023-06-01", finished_on: "2024-01-01") }
    let!(:period_3) { create(:induction_period, ect_at_school_period:, appropriate_body:, started_on: '2024-01-01', finished_on: nil) }
    let!(:ect_2_period) { create(:induction_period, appropriate_body:, started_on: '2023-02-01', finished_on: '2023-07-01') }

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
      let(:induction_period) { build(:induction_period, ect_at_school_period:, appropriate_body:, started_on: "2022-01-01", finished_on: "2023-01-01") }

      it "returns induction periods only for the specified instance's ect excluding the instance" do
        expect(described_class.siblings_of(induction_period)).to match_array([period_1, period_2, period_3])
      end
    end
  end
end
