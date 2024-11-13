module AppropriateBodies
  class ECTHasNoOngoingInductionPeriods < StandardError; end
  class ECTHasMultipleOngoingInductionPeriods < StandardError; end

  class ReleaseECT
    def initialize(appropriate_body:, pending_induction_submission:)
      @appropriate_body = appropriate_body
      @pending_induction_submission = pending_induction_submission
      @teacher = Teacher.find_by!(trn: pending_induction_submission.trn)
    end

    def release!
      InductionPeriod.transaction do
        ongoing_induction_period.update(
          finished_on: @pending_induction_submission.finished_on,
          number_of_terms: @pending_induction_submission.number_of_terms
        )

        @pending_induction_submission.destroy!
      end
    end

  private

    def ongoing_induction_period
      ongoing_induction_periods = InductionPeriod.ongoing.for_teacher(@teacher)

      if ongoing_induction_periods.count.zero?
        fail(ECTHasNoOngoingInductionPeriods, "TRN: #{@teacher.trn}")
      end

      if ongoing_induction_periods.count > 1
        fail(ECTHasMultipleOngoingInductionPeriods, "TRN: #{@teacher.trn}")
      end

      ongoing_induction_periods.first
    end
  end
end
