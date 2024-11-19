module Migration
  # NOTE: this is a PORO to help with collating mentorship period data when processing InductionRecords
  class MentorshipPeriodData
    attr_accessor :mentor_teacher, :start_date, :end_date, :start_source_id, :end_source_id

    def initialize(mentor_teacher:, start_date:, end_date:, start_source_id:, end_source_id:)
      @mentor_teacher = mentor_teacher
      @start_date = start_date
      @end_date = end_date
      @start_source_id = start_source_id
      @end_source_id = end_source_id
    end
  end
end
