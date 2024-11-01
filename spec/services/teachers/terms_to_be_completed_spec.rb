describe Teachers::TermsToBeCompleted do
  describe '#number_of_terms' do
    subject { described_class.new(teacher) }
    let(:teacher) { FactoryBot.create(:teacher) }

    context 'when the teacher does not have induction periods' do
      it 'returns nil' do
        expect(subject.number_of_terms).to eq(6)
      end
    end

    context 'when the teacher latest induction period does not have number_of_terms' do
      before do
        PeriodBuilders::InductionPeriodBuilder.new(
          appropriate_body: FactoryBot.create(:appropriate_body),
          school: FactoryBot.create(:school),
          teacher:
        ).build(started_on: Time.zone.today)
      end

      it 'returns the default number of terms' do
        expect(subject.number_of_terms).to eq(6)
      end

      context "with extensions" do
        before do
          FactoryBot.create(:induction_extension, teacher:, extension_terms: 2)
          FactoryBot.create(:induction_extension, teacher:, extension_terms: 1.1)
        end

        it 'returns the default number of terms plus the extensions' do
          expect(subject.number_of_terms).to eq(9.1)
        end
      end
    end

    context 'when the teacher latest induction period has number_of_terms' do
      let!(:induction_period) do
        PeriodBuilders::InductionPeriodBuilder.new(
          appropriate_body: FactoryBot.create(:appropriate_body),
          school: FactoryBot.create(:school),
          teacher:
        ).build(
          started_on: Time.zone.today - 1.year,
          finished_on: Time.zone.today - 3.months
        )
      end

      it 'returns the default number of terms' do
        expect(subject.number_of_terms).to eq(induction_period.number_of_terms)
      end

      context "with extensions" do
        before do
          FactoryBot.create(:induction_extension, teacher:, extension_terms: 2)
          FactoryBot.create(:induction_extension, teacher:, extension_terms: 1.1)
        end

        it 'returns the default number of terms plus the extensions' do
          expect(subject.number_of_terms).to eq(induction_period.number_of_terms + 3.1)
        end
      end
    end
  end
end
