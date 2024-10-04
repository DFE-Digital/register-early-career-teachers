describe Teachers::InductionPeriod do
  context '#induction_start_date' do
    subject { described_class.new(teacher).induction_start_date }

    let(:teacher) { FactoryBot.create(:teacher) }

    context 'when teacher does not have induction periods' do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context "when the teacher has induction periods" do
      let(:expected_date) { Date.new(2022, 10, 2) }
      let(:appropriate_body) { FactoryBot.create(:appropriate_body) }
      let(:school) { FactoryBot.create(:school) }
      let!(:first_induction_period) do
        PeriodBuilders::InductionPeriodBuilder.new(appropriate_body:, teacher:, school:)
          .build(started_on: expected_date, finished_on: Date.new(2023, 10, 2))
      end

      let!(:last_induction_period) do
        PeriodBuilders::InductionPeriodBuilder.new(appropriate_body:, teacher:, school:)
          .build(started_on: Date.new(2023, 10, 3))
      end

      it 'returns the start date of the first induction period' do
        expect(subject).to eq(expected_date)
      end
    end
  end
end
