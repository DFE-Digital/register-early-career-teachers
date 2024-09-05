describe TrainingPeriod do
  describe "associations" do
    it { is_expected.to belong_to(:trainee).inverse_of(:training_periods) }
    it { is_expected.to belong_to(:provider_partnership) }
    it { is_expected.to have_many(:declarations).inverse_of(:training_period) }
  end

  describe "validations" do
    subject { create(:training_period) }

    it { is_expected.to validate_presence_of(:started_on) }
    it { is_expected.to validate_presence_of(:trainee_id) }
    it { is_expected.to validate_presence_of(:trainee_type) }
    it { is_expected.to validate_presence_of(:provider_partnership_id) }

    context "uniqueness of finished_on scoped to trainee_id and trainee_type" do
      context "when the period matches the trainee_id, trainee_type and finished_on values of an existing training period" do
        let!(:existing_period) { create(:training_period) }
        let(:finished_on) { existing_period.finished_on }
        let(:started_on) { existing_period.finished_on - 1.day }
        let(:trainee_id) { existing_period.trainee_id }
        let(:trainee_type) { existing_period.trainee_type }

        subject { build(:training_period, trainee_id:, trainee_type:, started_on:, finished_on:) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(finished_on: ["matches the end date of an existing period for trainee"])
        end
      end
    end

    context "uniqueness of started_on scoped to trainee_id and trainee_type" do
      context "when the period matches the trainee_id, trainee_type and started_on values of an existing training period" do
        let!(:existing_period) { create(:training_period) }
        let(:started_on) { existing_period.started_on }
        let(:trainee_id) { existing_period.trainee_id }
        let(:trainee_type) { existing_period.trainee_type }

        subject { build(:training_period, trainee_id:, trainee_type:, started_on:) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(started_on: ["matches the start date of an existing period for trainee"])
        end
      end
    end

    context "trainee distinct period" do
      context "when the period has not finished yet" do
        context "when the trainee has a sibling training period starting later" do
          let!(:existing_period) { create(:training_period) }
          let(:trainee) { existing_period.trainee }
          let(:started_on) { existing_period.started_on - 1.year }

          subject { build(:training_period, trainee:, started_on:, finished_on: nil) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages).to include(base: ["Trainee periods cannot overlap"])
          end
        end
      end

      context "when the period has end date" do
        context "when the trainee has a sibling training period overlapping" do
          let!(:existing_period) { create(:training_period) }
          let(:trainee) { existing_period.trainee }
          let(:started_on) { existing_period.finished_on - 1.day }
          let(:finished_on) { started_on + 1.day }

          subject { build(:training_period, trainee:, started_on:, finished_on:) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages).to include(base: ["Trainee periods cannot overlap"])
          end
        end
      end
    end
  end

  describe "scopes" do
    let!(:trainee) { create(:ect_at_school_period) }
    let!(:provider_partnership) { create(:provider_partnership) }
    let!(:period_1) { create(:training_period, trainee:, provider_partnership:, started_on: '2023-01-01', finished_on: '2023-06-01') }
    let!(:period_2) { create(:training_period, trainee:, started_on: "2023-06-01", finished_on: "2024-01-01") }
    let!(:period_3) { create(:training_period, trainee:, provider_partnership:, started_on: '2024-01-01', finished_on: nil) }
    let!(:trainee_2_period) { create(:training_period, provider_partnership:, started_on: '2023-02-01', finished_on: '2023-07-01') }

    describe ".for_trainee" do
      it "returns training periods only for the specified trainee" do
        expect(described_class.for_trainee(trainee.id, trainee.class.name)).to match_array([period_1, period_2, period_3])
      end
    end

    describe ".for_provider_partnership" do
      it "returns training periods only for the specified provider partnership" do
        expect(described_class.for_provider_partnership(provider_partnership.id)).to match_array([period_1, period_3, trainee_2_period])
      end
    end

    describe ".trainee_siblings_of" do
      let(:training_period) { build(:training_period, trainee:, provider_partnership:, started_on: "2022-01-01", finished_on: "2023-01-01") }

      it "returns training periods only for the specified instance's trainee excluding the instance" do
        expect(described_class.trainee_siblings_of(training_period)).to match_array([period_1, period_2, period_3])
      end
    end
  end
end
