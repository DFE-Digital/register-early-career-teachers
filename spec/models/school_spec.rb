describe School do
  describe "associations" do
    it { is_expected.to have_many(:ect_at_school_periods) }
    it { is_expected.to have_many(:mentor_at_school_periods) }

    describe "on ect teachers" do
      let!(:school) { FactoryBot.create(:school) }
      let!(:teacher_1) { FactoryBot.create(:ect_at_school_period, school:, started_on: '2023-01-01', finished_on: '2023-06-01').teacher }
      let!(:ect_period) { FactoryBot.create(:ect_at_school_period, :active, teacher: teacher_1, school:, started_on: '2024-01-01') }
      let!(:teacher_2) { FactoryBot.create(:ect_at_school_period, :active, school:, started_on: '2023-02-01').teacher }
      let!(:teacher_3) { FactoryBot.create(:ect_at_school_period, school:, started_on: '2023-02-01', finished_on: '2023-06-01').teacher }

      describe ".current_ect_teachers" do
        subject { school.current_ect_teachers }

        it "only include teachers with ongoing ect periods" do
          expect(subject).to contain_exactly(teacher_1, teacher_2)
        end
      end

      describe ".ect_teachers" do
        subject { school.ect_teachers }

        it "only include teachers with ongoing ect periods" do
          expect(subject).to contain_exactly(teacher_1, teacher_2, teacher_3)
        end
      end
    end

    describe "on mentor teachers" do
      let!(:school) { FactoryBot.create(:school) }
      let!(:teacher_1) { FactoryBot.create(:mentor_at_school_period, school:, started_on: '2023-01-01', finished_on: '2023-06-01').teacher }
      let!(:mentor_period) { FactoryBot.create(:mentor_at_school_period, :active, teacher: teacher_1, school:, started_on: '2024-01-01') }
      let!(:teacher_2) { FactoryBot.create(:mentor_at_school_period, :active, school:, started_on: '2023-02-01').teacher }
      let!(:teacher_3) { FactoryBot.create(:mentor_at_school_period, school:, started_on: '2023-02-01', finished_on: '2023-06-01').teacher }

      describe ".current_mentor_teachers" do
        subject { school.current_mentor_teachers }

        it "only include teachers with ongoing ect periods" do
          expect(subject).to contain_exactly(teacher_1, teacher_2)
        end
      end

      describe ".mentor_teachers" do
        subject { school.mentor_teachers }

        it "only include teachers with ongoing ect periods" do
          expect(subject).to contain_exactly(teacher_1, teacher_2, teacher_3)
        end
      end
    end
  end

  describe "validations" do
    subject { FactoryBot.build(:school) }

    it { is_expected.to validate_presence_of(:urn) }
    it { is_expected.to validate_uniqueness_of(:urn) }
  end
end
