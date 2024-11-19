class MentorshipPeriodExtractor
  include Enumerable

  def initialize(induction_records:)
    @induction_records = induction_records
  end

  def each(&block)
    return to_enum(__method__) { mentorship_periods.size } unless block_given?

    mentorship_periods.each(&block)
  end

private

  def mentorship_periods
    @mentorship_periods ||= build_mentorship_periods
  end

  def build_mentorship_periods
    current_period = nil
    current_mentor = nil

    @induction_records.each_with_object([]) do |induction_record, periods|
      mentor_id = induction_record.mentor_profile_id

      next if current_mentor.nil? && mentor_id.nil?

      if current_mentor != mentor_id
        current_mentor = mentor_id

        mentor_teacher = ::Teacher.find_by(legacy_mentor_id: mentor_id)

        current_period = Migration::MentorshipPeriodData.new(mentor_teacher:,
                                                             start_date: induction_record.start_date,
                                                             end_date: induction_record.end_date,
                                                             start_source_id: induction_record.id,
                                                             end_source_id: induction_record.id)
        periods << current_period
      else
        current_period.end_date = induction_record.end_date
        current_period.end_source_id = induction_record.id
      end
    end
  end
end
