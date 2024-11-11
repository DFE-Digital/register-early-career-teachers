describe PendingInductionSubmissions::Name do
  describe '#full_name' do
    subject { PendingInductionSubmissions::Name.new(pending_induction_submission) }

    context 'when pending_induction_submission is missing' do
      let(:pending_induction_submission) { nil }

      it 'returns nil' do
        expect(subject.full_name).to be_nil
      end
    end

    context 'when a corrected_name is set' do
      let(:pending_induction_submission) { FactoryBot.build(:pending_induction_submission) }

      it 'returns the corrected name' do
        expect(subject.full_name).to eql("#{pending_induction_submission.trs_first_name} #{pending_induction_submission.trs_last_name}")
      end
    end
  end
end
