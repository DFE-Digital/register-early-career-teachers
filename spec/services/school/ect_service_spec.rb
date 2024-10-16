describe School::ECTService do
  let(:school) { FactoryBot.create(:school) }
  let(:ect) { FactoryBot.create(:teacher) }
  let(:mentor) { FactoryBot.create(:teacher) }
  let(:mentor_period) { FactoryBot.create(:mentor_at_school_period, school:, teacher: mentor, started_on: 2.years.ago, finished_on: nil) }
  let(:ect_period) { FactoryBot.create(:ect_at_school_period, school:, teacher: ect, started_on: 2.years.ago, finished_on: nil) }

  subject { described_class.new(school.id) }

  before do
    FactoryBot.create(:training_period, mentor_at_school_period: mentor_period, ect_at_school_period: nil, started_on: 1.year.ago, finished_on: nil)
    FactoryBot.create(:mentorship_period, mentor: mentor_period, mentee: ect_period, started_on: 1.year.ago)
  end

  describe '#fetch_etcs_and_mentors' do
    it 'returns ECTs and mentors for a given school' do
      result = subject.fetch_etcs_and_mentors

      expect(result).to eq([
        {
          ect: ect.full_name,
          mentor: mentor.full_name,
          status: School::ECTService::IN_PROGRESS,
        }
      ])
    end
  end
end
