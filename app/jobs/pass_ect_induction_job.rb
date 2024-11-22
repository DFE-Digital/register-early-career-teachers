class PassECTInductionJob < ApplicationJob
  def perform(trn:, completion_date:, pending_induction_submission_id:, teacher_id:)
    ActiveRecord::Base.transaction do
      api_client.pass_induction!(trn:, completion_date:)

      Teacher.find(teacher_id).update!(induction_completion_submitted_to_trs_at: Time.zone.now)

      PendingInductionSubmission.find(pending_induction_submission_id).destroy!
    end
  end

private

  def api_client
    TRS::APIClient.new
  end
end
