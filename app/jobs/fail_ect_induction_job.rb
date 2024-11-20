class FailECTInductionJob < ApplicationJob
  def perform(trn:, completion_date:, pending_induction_submission_id:, teacher_id:)
    api_client.fail_induction!(trn:, completion_date:)

    Teacher.find(teacher_id).update!(induction_completion_submitted_to_trs_at: Time.zone.now)

    PendingInductionSubmission.find(pending_induction_submission_id).destroy!
  end

private

  def api_client
    TRS::APIClient.new
  end
end
