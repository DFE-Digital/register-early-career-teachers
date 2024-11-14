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

  describe '#current_ects' do
    it 'returns Teacher instances of all the ECTs currently at the school' do
      expect(subject.current_ects).to contain_exactly(ect_1)
    end
  end

  describe '#current_ect_periods' do
    it 'returns the current ECTAtSchoolPeriod instance of all the ECTs currently at the school' do
      expect(subject.current_ect_periods).to contain_exactly(ect_1_current_period)
    end
  end

  describe '#current_mentors' do
    it 'returns Teacher instances of all the Mentors currently at the school' do
      expect(subject.current_mentors).to contain_exactly(mentor_1, mentor_2)
    end
  end

  describe '#current_mentor_periods' do
    it 'returns the current MentorAtSchoolPeriod instance of all the Mentors currently at the school' do
      expect(subject.current_mentor_periods).to contain_exactly(mentor_1_current_period, mentor_2_current_period)
    end
  end

  describe '#latest_period_of_all_ects' do
    it 'returns a ECTAtSchoolPeriod instance for the latest period of any ECT at the school ever' do
      expect(subject.latest_period_of_all_ects).to contain_exactly(ect_1_current_period, ect_2_period_1)
    end
  end

  describe '#latest_period_of_all_mentors' do
    it 'returns a ECTAtSchoolPeriod instance for the latest period of any Mentor at the school ever' do
      expect(subject.latest_period_of_all_mentors).to contain_exactly(mentor_1_current_period, mentor_2_current_period)
    end
  end
end
