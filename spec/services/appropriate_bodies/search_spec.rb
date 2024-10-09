describe AppropriateBodies::Search do
  describe 'dealing with search terms' do
    subject { described_class.new(query_string) }

    context 'when the search string is blank' do
      before { allow(AppropriateBody).to receive(:all).and_call_original }

      let(:query_string) { ' ' }

      it 'applies no conditions and returns all appropriate bodies' do
        subject.search

        expect(AppropriateBody).to have_received(:all).once.with(no_args)
      end
    end

    context 'when the search string contains some text' do
      before { allow(AppropriateBody).to receive(:where).and_call_original }

      let(:query_string) { 'Captain Scrummy' }

      it 'initiates a full text search with the given search string' do
        subject.search

        expect(AppropriateBody).to have_received(:where).once.with("name ILIKE ?", "%#{query_string}%")
      end
    end
  end
end
