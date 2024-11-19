describe InductionExtension do
  describe "associations" do
    it { is_expected.to belong_to(:teacher) }
  end

  describe 'validation' do
    describe 'number_of_terms' do
      it 'allows valid values to be saved' do
        # NOTE: we're actually saving them here to ensure PostgreSQL's column accepts the necessary
        #       precision and scale
        expect(FactoryBot.create(:induction_extension, number_of_terms: 0.1)).to be_valid
        expect(FactoryBot.create(:induction_extension, number_of_terms: 11.9)).to be_valid
      end

      it 'prohibits numbers outside the range 1..12' do
        expect(subject).not_to allow_value(0).for(:number_of_terms)
        expect(subject).not_to allow_value(12.1).for(:number_of_terms)
      end
    end
  end
end
