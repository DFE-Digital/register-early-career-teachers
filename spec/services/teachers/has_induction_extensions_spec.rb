describe Teachers::HasInductionExtensions do
  describe '#number_of_terms' do
    subject { described_class.new(teacher).yes_or_no }
    let(:teacher) { FactoryBot.create(:teacher) }

    context 'without extensions' do
      it 'returns no' do
        expect(subject).to eq("No")
      end
    end

    context 'with extensions' do
      let!(:extension) { FactoryBot.create(:induction_extension, teacher:) }

      it 'returns yes' do
        expect(subject).to eq("Yes")
      end
    end
  end
end
