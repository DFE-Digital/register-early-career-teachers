describe Teachers::Search do
  describe 'dealing with search terms' do
    subject { Teachers::Search.new(query_string) }

    context 'when there are 7 digit numbers in the search string' do
      before { allow(Teacher).to receive(:where).and_call_original }
      let(:query_string) { 'the quick brown 1234567 jumped over the lazy 2345678' }

      it 'searches for all present 7 digit numbers (TRNs)' do
        subject.search

        expect(Teacher).to have_received(:where).with(trn: %w[1234567 2345678])
      end
    end

    context 'when the search string is blank' do
      before { allow(Teacher).to receive(:all).and_call_original }

      let(:query_string) { ' ' }

      it 'applies no conditions and returns all teachers' do
        subject.search

        expect(Teacher).to have_received(:all).once.with(no_args)
      end
    end

    context 'when the search string contains some text' do
      before { allow(Teacher).to receive(:search).and_call_original }

      let(:query_string) { 'Captain Scrummy' }

      it 'initiates a full text search with the given search string' do
        subject.search

        expect(Teacher).to have_received(:search).once.with(query_string)
      end
    end
  end
end
