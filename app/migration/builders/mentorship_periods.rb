module Builders
  class MentorshipPeriods
    attr_reader :teacher, :mentorship_period_data

    def initialize(teacher:, mentorship_period_data:)
      @teacher = teacher
      @mentorship_period_data = mentorship_period_data
    end

    def process!
      period_date = Data.define(:started_on, :finished_on)

      mentorship_period_data.each do |period|
        period_dates = period_date.new(started_on: period.start_date, finished_on: period.end_date)
        teacher_period = teacher.ect_at_school_periods.containing_period(period_dates).first
        raise ActiveRecord::RecordNotFound, "No ECTAtSchoolPeriod found for mentorship dates" if teacher_period.nil?

        raise ActiveRecord::RecordNotFound, "Mentor not found in migrated data" if period.mentor_teacher.nil?

        mentor_period = period.mentor_teacher.mentor_at_school_periods
          .where(school_id: teacher_period.school_id)
          .containing_period(period_dates).first
        raise ActiveRecord::RecordNotFound, "No MentorAtSchoolPeriod found for mentorship dates" if mentor_period.nil?

        ::MentorshipPeriod.create!(mentee: teacher_period,
                                   mentor: mentor_period,
                                   started_on: period.start_date,
                                   finished_on: period.end_date,
                                   legacy_start_id: period.start_source_id,
                                   legacy_end_id: period.end_source_id)
      end
    end
  end
end
