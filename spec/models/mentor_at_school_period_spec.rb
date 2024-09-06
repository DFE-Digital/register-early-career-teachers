describe MentorAtSchoolPeriod do
  describe "associations" do
    it { is_expected.to belong_to(:school).inverse_of(:mentor_at_school_periods) }
    it { is_expected.to belong_to(:teacher).inverse_of(:mentor_at_school_periods) }
    it { is_expected.to have_many(:mentorship_periods).inverse_of(:mentor) }
    it { is_expected.to have_many(:training_periods) }
  end

  describe "validations" do
    subject { FactoryBot.build(:mentor_at_school_period) }

    it { is_expected.to validate_presence_of(:started_on) }
    it { is_expected.to validate_presence_of(:school_id) }
    it { is_expected.to validate_presence_of(:teacher_id) }

    context "uniqueness of finished_on scoped to teacher_id and school_id" do
      context "when the period matches the teacher_id, school_id and finished_on values of an existing mentor period" do
        let!(:existing_period) { FactoryBot.create(:mentor_at_school_period) }
        let(:finished_on) { existing_period.finished_on }
        let(:started_on) { existing_period.finished_on - 1.day }
        let(:school_id) { existing_period.school_id }
        let(:teacher_id) { existing_period.teacher_id }

        subject { FactoryBot.build(:mentor_at_school_period, teacher_id:, school_id:, started_on:, finished_on:) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(finished_on: ["matches the end date of an existing period"])
        end
      end
    end

    context "uniqueness of started_on scoped to teacher_id and school_id" do
      context "when the period matches the teacher_id, school_id and started_on values of an existing mentor period" do
        let!(:existing_period) { FactoryBot.create(:mentor_at_school_period) }
        let(:started_on) { existing_period.started_on }
        let(:school_id) { existing_period.school_id }
        let(:teacher_id) { existing_period.teacher_id }

        subject { FactoryBot.build(:mentor_at_school_period, teacher_id:, school_id:, started_on:) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(started_on: ["matches the start date of an existing period"])
        end
      end
    end

    context "teacher school distinct period" do
      context "when the period has not finished yet" do
        context "when the teacher has a school sibling mentor_at_school_period starting later" do
          let!(:existing_period) { FactoryBot.create(:mentor_at_school_period) }
          let(:teacher_id) { existing_period.teacher_id }
          let(:school_id) { existing_period.school_id }
          let(:started_on) { existing_period.started_on - 1.year }

          subject { FactoryBot.build(:mentor_at_school_period, teacher_id:, school_id:, started_on:, finished_on: nil) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages).to include(base: ["Teacher School ECT periods cannot overlap"])
          end
        end
      end

      context "when the period has end date" do
        context "when the teacher has a sibling ect_at_school_period overlapping" do
          let!(:existing_period) { FactoryBot.create(:mentor_at_school_period) }
          let(:teacher_id) { existing_period.teacher_id }
          let(:school_id) { existing_period.school_id }
          let(:started_on) { existing_period.finished_on - 1.day }
          let(:finished_on) { started_on + 1.day }

          subject { FactoryBot.build(:mentor_at_school_period, teacher_id:, school_id:, started_on:, finished_on:) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages).to include(base: ["Teacher School ECT periods cannot overlap"])
          end
        end
      end
    end
  end

  describe "scopes" do
    let!(:teacher) { FactoryBot.create(:teacher) }
    let!(:school) { FactoryBot.create(:school) }
    let!(:school_2) { FactoryBot.create(:school) }
    let!(:period_1) { FactoryBot.create(:mentor_at_school_period, teacher:, school:, started_on: '2023-01-01', finished_on: '2023-06-01') }
    let!(:period_2) { FactoryBot.create(:mentor_at_school_period, teacher:, school: school_2, started_on: "2023-06-01", finished_on: "2024-01-01") }
    let!(:period_3) { FactoryBot.create(:mentor_at_school_period, teacher:, school:, started_on: '2024-01-01', finished_on: nil) }
    let!(:teacher_2_period) { FactoryBot.create(:mentor_at_school_period, school:, started_on: '2023-02-01', finished_on: '2023-07-01') }

    describe ".for_school" do
      it "returns mentor periods only for the specified school" do
        expect(described_class.for_school(school_2.id)).to match_array([period_2])
      end
    end

    describe ".for_teacher" do
      it "returns mentor periods only for the specified teacher" do
        expect(described_class.for_teacher(teacher.id)).to match_array([period_1, period_2, period_3])
      end
    end

    describe ".siblings_of" do
      let!(:mentor_at_school_period) { FactoryBot.build(:mentor_at_school_period, teacher:, school:, started_on: "2022-01-01", finished_on: "2023-01-01") }

      it "returns mentor periods only for the specified instance's teacher excluding the instance" do
        expect(described_class.siblings_of(mentor_at_school_period)).to match_array([period_1, period_2, period_3])
      end
    end

    describe ".school_siblings_of" do
      let!(:mentor_at_school_period) { FactoryBot.build(:mentor_at_school_period, teacher:, school: school_2, started_on: "2022-01-01", finished_on: "2023-01-01") }

      it "returns mentor periods for the specified instance's teacher and school excluding the instance" do
        expect(described_class.school_siblings_of(mentor_at_school_period)).to match_array([period_2])
      end
    end
  end
end
