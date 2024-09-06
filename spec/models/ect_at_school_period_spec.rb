describe ECTAtSchoolPeriod do
  describe "associations" do
    it { is_expected.to belong_to(:school).inverse_of(:ect_at_school_periods) }
    it { is_expected.to belong_to(:teacher).inverse_of(:ect_at_school_periods) }
    it { is_expected.to have_many(:induction_periods).inverse_of(:ect_at_school_period) }
    it { is_expected.to have_many(:mentorship_periods).inverse_of(:mentee) }
    it { is_expected.to have_many(:training_periods) }
  end

  describe "validations" do
    subject { FactoryBot.create(:ect_at_school_period) }

    it { is_expected.to validate_uniqueness_of(:finished_on).scoped_to(:teacher_id).allow_nil }
    it { is_expected.to validate_presence_of(:started_on) }
    it { is_expected.to validate_uniqueness_of(:started_on).scoped_to(:teacher_id) }
    it { is_expected.to validate_presence_of(:school_id) }
    it { is_expected.to validate_presence_of(:teacher_id) }

    context "teacher distinct period" do
      context "when the period has not finished yet" do
        context "when the teacher has a sibling ect_at_school_period starting later" do
          let!(:existing_period) { FactoryBot.create(:ect_at_school_period) }
          let(:teacher_id) { existing_period.teacher_id }
          let(:started_on) { existing_period.started_on - 1.year }

          subject { FactoryBot.build(:ect_at_school_period, teacher_id:, started_on:, finished_on: nil) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages).to include(base: ["Teacher ECT periods cannot overlap"])
          end
        end
      end

      context "when the period has end date" do
        context "when the teacher has a sibling ect_at_school_period overlapping" do
          let!(:existing_period) { FactoryBot.create(:ect_at_school_period) }
          let(:teacher_id) { existing_period.teacher_id }
          let(:started_on) { existing_period.finished_on - 1.day }
          let(:finished_on) { started_on + 1.day }

          subject { FactoryBot.build(:ect_at_school_period, teacher_id:, started_on:, finished_on:) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages).to include(base: ["Teacher ECT periods cannot overlap"])
          end
        end
      end
    end
  end

  describe "scopes" do
    let!(:teacher) { FactoryBot.create(:teacher) }
    let!(:school) { FactoryBot.create(:school) }
    let!(:period_1) { FactoryBot.create(:ect_at_school_period, teacher:, school:, started_on: '2023-01-01', finished_on: '2023-06-01') }
    let!(:period_2) { FactoryBot.create(:ect_at_school_period, teacher:, started_on: "2023-06-01", finished_on: "2024-01-01") }
    let!(:period_3) { FactoryBot.create(:ect_at_school_period, teacher:, school:, started_on: '2024-01-01', finished_on: nil) }
    let!(:teacher_2_period) { FactoryBot.create(:ect_at_school_period, school:, started_on: '2023-02-01', finished_on: '2023-07-01') }

    describe ".for_teacher" do
      it "returns ect periods only for the specified teacher" do
        expect(described_class.for_teacher(teacher.id)).to match_array([period_1, period_2, period_3])
      end
    end

    describe ".siblings_of" do
      let(:ect_at_school_period) { FactoryBot.build(:ect_at_school_period, teacher:, school:, started_on: "2022-01-01", finished_on: "2023-01-01") }

      it "returns ect periods only for the specified instance's teacher excluding the instance" do
        expect(described_class.siblings_of(ect_at_school_period)).to match_array([period_1, period_2, period_3])
      end
    end
  end
end
