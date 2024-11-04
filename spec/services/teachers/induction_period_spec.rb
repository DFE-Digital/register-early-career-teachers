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
      let!(:first_induction_period) do
        FactoryBot.create(:induction_period, appropriate_body:, teacher:, started_on: expected_date, finished_on: Date.new(2023, 10, 2))
      end

      let!(:last_induction_period) do
        FactoryBot.create(:induction_period, appropriate_body:, teacher:, started_on: Date.new(2023, 10, 3))
      end

      it 'returns the start date of the first induction period' do
        expect(subject).to eq(expected_date)
      end
    end
  end

  context '#active_induction_period' do
    subject { described_class.new(teacher).active_induction_period }

    let(:teacher) { FactoryBot.create(:teacher) }

    before do
      InductionPeriod.new(
        appropriate_body: FactoryBot.create(:appropriate_body),
        teacher:,
        started_on: Date.new(2023, 10, 3),
        finished_on: Date.new(2023, 12, 3)
      )
    end

    context 'when teacher does not have an active induction period' do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context "when the teacher has an active induction period" do
      let!(:active_induction_period) do
        FactoryBot.create(
          :induction_period,
          appropriate_body: FactoryBot.create(:appropriate_body),
          teacher:,
          started_on: Date.new(2024, 10, 3),
          finished_on: nil
        )
      end

      it 'returns the active induction period for the teacher' do
        expect(subject).to eq(active_induction_period)
      end
    end
  end
end
