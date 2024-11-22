module PendingInductionSubmissions
  class Search
    attr_reader :scope

    def initialize(appropriate_body: nil)
      @scope = PendingInductionSubmission.all

      where_appropriate_body_is(appropriate_body)
    end

    def pending_induction_submissions
      @scope
    end

  private

    def where_appropriate_body_is(appropriate_body)
      return unless appropriate_body

      scope.merge!(PendingInductionSubmission.where(appropriate_body:))
    end
  end
end
