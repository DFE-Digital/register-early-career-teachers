describe Teachers::InductionExtensions do
  describe '#yes_or_no' do
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

  describe "#formatted_number_of_terms" do
    let(:total) { 5.1 }
    let(:teacher) { FactoryBot.create(:teacher) }

    it "returns the number of terms followed by the " do
      allow(teacher.induction_extensions).to receive(:sum).and_return(total)

      expect(Teachers::InductionExtensions.new(teacher).formatted_number_of_terms).to eql("#{total} terms")
    end
  end
end
