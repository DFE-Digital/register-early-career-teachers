describe TrainingPeriod do
  describe "associations" do
    it { is_expected.to belong_to(:ect_at_school_period).class_name("ECTAtSchoolPeriod").inverse_of(:training_periods) }
    it { is_expected.to belong_to(:mentor_at_school_period).inverse_of(:training_periods) }
    it { is_expected.to belong_to(:provider_partnership) }
    it { is_expected.to have_many(:declarations).inverse_of(:training_period) }
  end

  describe "validations" do
    subject { FactoryBot.create(:training_period) }

    it { is_expected.to validate_presence_of(:started_on) }
    it { is_expected.to validate_presence_of(:provider_partnership_id) }

    context "uniqueness of finished_on scoped to trainee ids" do
      context "when the period matches the ect_at_school_period_id, mentor_at_school_period_id and finished_on values
               of an existing training period" do
        let!(:existing_period) { FactoryBot.create(:training_period) }
        let(:finished_on) { existing_period.finished_on }
        let(:started_on) { existing_period.finished_on - 1.day }
        let(:ect_at_school_period_id) { existing_period.ect_at_school_period_id }
        let(:mentor_at_school_period_id) { existing_period.mentor_at_school_period_id }

        subject { FactoryBot.build(:training_period, ect_at_school_period_id:, mentor_at_school_period_id:, started_on:, finished_on:) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(finished_on: ["matches the end date of an existing period for trainee"])
        end
      end
    end

    context "uniqueness of started_on scoped to trainee ids" do
      context "when the period matches the ect_at_school_period_id, mentor_at_school_period_id and finished_on values
               of an existing training period" do
        let!(:existing_period) { FactoryBot.create(:training_period) }
        let(:started_on) { existing_period.started_on }
        let(:ect_at_school_period_id) { existing_period.ect_at_school_period_id }
        let(:mentor_at_school_period_id) { existing_period.mentor_at_school_period_id }

        subject { FactoryBot.build(:training_period, ect_at_school_period_id:, mentor_at_school_period_id:, started_on:) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(started_on: ["matches the start date of an existing period for trainee"])
        end
      end
    end

    context "exactly one id of trainee present" do
      context "when ect_at_school_period_id and mentor_at_school_period_id are all nil" do
        let!(:existing_period) { FactoryBot.create(:training_period) }
        let(:started_on) { existing_period.started_on - 1.year }

        subject do
          FactoryBot.build(:training_period, ect_at_school_period_id: nil, mentor_at_school_period_id: nil, started_on:, finished_on: nil)
        end

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages[:base]).to include("Id of trainee missing")
        end
      end

      context "when ect_at_school_period_id and mentor_at_school_period_id are all set" do
        let!(:existing_period) { FactoryBot.create(:training_period) }
        let(:started_on) { existing_period.started_on - 1.year }

        subject do
          FactoryBot.build(:training_period,
                           ect_at_school_period_id: 200,
                           mentor_at_school_period_id: 300,
                           started_on:,
                           finished_on: nil)
        end

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(base: ["Only one id of trainee required. Two given"])
        end
      end
    end

    context "trainee distinct period" do
      context "when the period has not finished yet" do
        context "when the trainee has a sibling training period starting later" do
          let!(:existing_period) { FactoryBot.create(:training_period) }
          let(:ect_at_school_period_id) { existing_period.ect_at_school_period_id }
          let(:started_on) { existing_period.started_on - 1.year }

          subject { FactoryBot.build(:training_period, ect_at_school_period_id:, started_on:, finished_on: nil) }

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
          let!(:existing_period) { FactoryBot.create(:training_period) }
          let(:ect_at_school_period_id) { existing_period.ect_at_school_period_id }
          let(:started_on) { existing_period.finished_on - 1.day }
          let(:finished_on) { started_on + 1.day }

          subject { FactoryBot.build(:training_period, ect_at_school_period_id:, started_on:, finished_on:) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages[:base]).to include("Trainee periods cannot overlap")
          end
        end
      end
    end
  end

  describe "scopes" do
    let!(:ect_at_school_period) { FactoryBot.create(:ect_at_school_period) }
    let!(:mentor_at_school_period) { FactoryBot.create(:mentor_at_school_period) }
    let!(:provider_partnership) { FactoryBot.create(:provider_partnership) }
    let!(:period_1) { FactoryBot.create(:training_period, :for_ect, ect_at_school_period:, provider_partnership:, started_on: '2023-01-01', finished_on: '2023-06-01') }
    let!(:period_2) { FactoryBot.create(:training_period, :for_ect, ect_at_school_period:, started_on: "2023-06-01", finished_on: "2024-01-01") }
    let!(:period_3) { FactoryBot.create(:training_period, :for_ect, ect_at_school_period:, provider_partnership:, started_on: '2024-01-01', finished_on: nil) }
    let!(:period_4) { FactoryBot.create(:training_period, :for_mentor, mentor_at_school_period:, provider_partnership:, started_on: '2023-02-01', finished_on: '2023-07-01') }

    describe ".for_ect" do
      it "returns training periods only for the specified ect_at_school_period_id" do
        expect(described_class.for_ect(ect_at_school_period.id)).to match_array([period_1, period_2, period_3])
      end
    end

    describe ".for_mentor" do
      it "returns training periods only for the specified mentor_at_school_period_id" do
        expect(described_class.for_mentor(mentor_at_school_period.id)).to match_array([period_4])
      end
    end

    describe ".for_provider_partnership" do
      it "returns training periods only for the specified provider partnership" do
        expect(described_class.for_provider_partnership(provider_partnership.id)).to match_array([period_1, period_3, period_4])
      end
    end

    describe ".trainee_siblings_of" do
      it "returns training periods only for the specified instance's trainee excluding the instance" do
        expect(described_class.trainee_siblings_of(period_3)).to match_array([period_1, period_2])
      end

      context "when there are no siblings" do
        it "returns an empty list" do
          expect(described_class.trainee_siblings_of(period_4)).to match_array([])
        end
      end
    end
  end
end
