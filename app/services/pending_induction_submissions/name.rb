class PendingInductionSubmissions::Name
  attr_reader :pending_induction_submission

  def initialize(pending_induction_submission)
    @pending_induction_submission = pending_induction_submission
  end

  def full_name
    return unless pending_induction_submission

    %(#{pending_induction_submission.trs_first_name} #{pending_induction_submission.trs_last_name})
  end
end
