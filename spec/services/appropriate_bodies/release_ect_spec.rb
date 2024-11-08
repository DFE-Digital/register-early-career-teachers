describe AppropriateBodies::ReleaseECT do
  let(:induction_period) { FactoryBot.create(:induction_period, :active) }
  let(:pending_induction_submission) do
    FactoryBot.create(
      :pending_induction_submission,
      :finishing,
      appropriate_body: induction_period.appropriate_body,
      trn: induction_period.teacher.trn
    )
  end

  subject do
    AppropriateBodies::ReleaseECT.new(
      appropriate_body: induction_period.appropriate_body,
      pending_induction_submission:
    )
  end

  describe 'initialization' do
    it 'is initialized with an appropriate body and pending induction submission' do
      expect(subject).to be_a(AppropriateBodies::ReleaseECT)
    end

    it 'sets assigns the right teacher' do
      expect(subject.instance_variable_get(:@teacher)).to eql(induction_period.teacher)
    end
  end

  describe 'release!' do
    it 'closes the induction period setting the finished_on date and number_of_terms' do
      expect(induction_period.number_of_terms).to be_blank
      expect(induction_period.finished_on).to be_blank

      subject.release!
      induction_period.reload

      expect(induction_period.number_of_terms).to be_present
      expect(induction_period.finished_on).to be_present

      expect(induction_period.number_of_terms).to eql(pending_induction_submission.number_of_terms)
      expect(induction_period.finished_on).to eql(pending_induction_submission.finished_on)
    end

    it 'destroys the pending_induction_submission' do
      subject.release!
      expect(PendingInductionSubmission.where(id: pending_induction_submission.id)).to be_empty
    end
  end
end
