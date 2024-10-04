describe PeriodBuilders::InductionPeriodBuilder do
  subject do
    described_class.new(
      appropriate_body: FactoryBot.create(:appropriate_body),
      teacher: FactoryBot.create(:teacher),
      school: FactoryBot.create(:school)
    ).build(started_on:, finished_on:)
  end

  let(:started_on) { Date.new(2022, 10, 2) }
  let(:finished_on) { nil }

  context 'when I provide started_on' do
    it 'creates an ECTAtSchoolPeriod with given started_on' do
      expect(subject.ect_at_school_period).to have_attributes(started_on:)
    end

    it 'creates an InductionPeriod without number_of_terms' do
      expect(subject.number_of_terms).to be_nil
    end

    it 'creates an InductionPeriod with given started_on' do
      expect(subject).to have_attributes(started_on:)
    end

    context 'when I provide finished_on' do
      let(:finished_on) { Date.new(2023, 10, 2) }

      it 'creates an ECTAtSchoolPeriod with given started_on' do
        expect(subject.ect_at_school_period).to have_attributes(started_on:)
      end

      it 'creates an ECTAtSchoolPeriod with given finished_on' do
        expect(subject.ect_at_school_period).to have_attributes(finished_on:)
      end

      it 'creates an InductionPeriod with number_of_terms' do
        expect(subject.number_of_terms).not_to be_nil
      end

      it 'creates an InductionPeriod with given started_on' do
        expect(subject).to have_attributes(started_on:)
      end

      it 'creates an InductionPeriod with given finished_on' do
        expect(subject).to have_attributes(finished_on:)
      end
    end
  end
end
