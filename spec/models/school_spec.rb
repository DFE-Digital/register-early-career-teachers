describe School do
  describe "associations" do
    it { is_expected.to belong_to(:gias_school).class_name("GIAS::School").with_foreign_key(:urn).inverse_of(:school) }
    it { is_expected.to have_many(:ect_at_school_periods) }
    it { is_expected.to have_many(:mentor_at_school_periods) }

    subject(:school) { FactoryBot.create(:school) }

    describe ".current_mentors" do
      let!(:active_mentors) { FactoryBot.create_list(:mentor_at_school_period, 2, :active, school:) }
      let!(:old_mentors) { FactoryBot.create_list(:mentor_at_school_period, 2, school:) }

      it "returns only ongoing mentors registered at the school" do
        expect(school.current_mentors).to match_array(active_mentors)
      end
    end

    describe ".ect_teachers" do
      let!(:teacher_1) { FactoryBot.create(:ect_at_school_period, school:, started_on: '2023-01-01', finished_on: '2023-06-01').teacher }
      let!(:ect_period) { FactoryBot.create(:ect_at_school_period, :active, teacher: teacher_1, school:, started_on: '2024-01-01') }
      let!(:teacher_2) { FactoryBot.create(:ect_at_school_period, :active, school:, started_on: '2023-02-01').teacher }
      let!(:teacher_3) { FactoryBot.create(:ect_at_school_period, school:, started_on: '2023-02-01', finished_on: '2023-06-01').teacher }

      subject { school.ect_teachers }

      it "only include teachers with ongoing ect periods" do
        expect(subject).to contain_exactly(teacher_1, teacher_2, teacher_3)
      end
    end

    describe ".mentor_teachers" do
      let!(:teacher_1) { FactoryBot.create(:mentor_at_school_period, school:, started_on: '2023-01-01', finished_on: '2023-06-01').teacher }
      let!(:mentor_period) { FactoryBot.create(:mentor_at_school_period, :active, teacher: teacher_1, school:, started_on: '2024-01-01') }
      let!(:teacher_2) { FactoryBot.create(:mentor_at_school_period, :active, school:, started_on: '2023-02-01').teacher }
      let!(:teacher_3) { FactoryBot.create(:mentor_at_school_period, school:, started_on: '2023-02-01', finished_on: '2023-06-01').teacher }

      subject { school.mentor_teachers }

      it "only include teachers with ongoing ect periods" do
        expect(subject).to contain_exactly(teacher_1, teacher_2, teacher_3)
      end
    end
  end

  describe "validations" do
    subject { FactoryBot.build(:school) }

    it { is_expected.to validate_presence_of(:urn) }
    it { is_expected.to validate_uniqueness_of(:urn) }
  end
end
