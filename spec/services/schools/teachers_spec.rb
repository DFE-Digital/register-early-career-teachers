describe Schools::Teachers do
  let(:school) { ect_1_period_1.school }
  let(:ect_1) { ect_1_period_1.teacher }
  let(:ect_2) { ect_2_period_1.teacher }
  let(:mentor_1) { mentor_1_period_1.teacher }
  let(:mentor_2) { mentor_2_current_period.teacher }
  let!(:ect_1_period_1) { FactoryBot.create(:ect_at_school_period, started_on: 2.years.ago.to_date, finished_on: 18.months.ago.to_date) }
  let!(:ect_1_current_period) { FactoryBot.create(:ect_at_school_period, :active, teacher: ect_1, school:, started_on: 1.year.ago) }
  let!(:ect_2_period_1) { FactoryBot.create(:ect_at_school_period, school:) }
  let!(:mentor_1_period_1) { FactoryBot.create(:mentor_at_school_period, school:, started_on: 2.years.ago.to_date, finished_on: 18.months.ago.to_date) }
  let!(:mentor_1_current_period) { FactoryBot.create(:mentor_at_school_period, :active, teacher: mentor_1, school:, started_on: 1.year.ago) }
  let!(:mentor_2_current_period) { FactoryBot.create(:mentor_at_school_period, :active, school:) }

  subject { described_class.new(school) }

  describe '#all_ects' do
    it 'returns Teacher instances of all the ECTs at the school ever' do
      expect(subject.all_ects).to contain_exactly(ect_1, ect_2)
    end
  end

  describe '#all_mentors' do
    it 'returns Teacher instances of all the Mentors at the school ever' do
      expect(subject.all_mentors).to contain_exactly(mentor_1, mentor_2)
    end
  end
end
