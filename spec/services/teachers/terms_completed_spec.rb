describe Teachers::TermsCompleted do
  describe '#number_of_terms' do
    subject { described_class.new(teacher).formatted_terms_completed }
    let(:teacher) { FactoryBot.create(:teacher) }

    context 'when the teacher does not have induction periods' do
      it 'returns nil' do
        expect(subject).to eq("0.0 of 6.0")
      end
    end

    context 'without extensions' do
      it 'returns the default number of terms' do
        expect(subject).to eq("0.0 of 6.0")
      end

      context "with extensions" do
        before do
          FactoryBot.create(:induction_extension, teacher:, number_of_terms: 2)
          FactoryBot.create(:induction_extension, teacher:, number_of_terms: 1.1)
        end

        it 'returns the default number of terms plus the extensions' do
          expect(subject).to eq("0.0 of 9.1")
        end
      end
    end

    context 'when the teacher has induction periods' do
      let!(:induction_period) { FactoryBot.create(:induction_period, teacher:, number_of_terms: 2) }

      context 'without extensions' do
        it 'returns the default number of terms' do
          expect(subject).to eq("2.0 of 6.0")
        end

        context "with extensions" do
          before do
            FactoryBot.create(:induction_extension, teacher:, number_of_terms: 2)
            FactoryBot.create(:induction_extension, teacher:, number_of_terms: 1.1)
          end

          it 'returns the default number of terms plus the extensions' do
            expect(subject).to eq("2.0 of 9.1")
          end
        end
      end
    end
  end
end
