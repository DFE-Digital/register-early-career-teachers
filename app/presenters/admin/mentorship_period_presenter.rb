module Admin
  class MentorshipPeriodPresenter < SimpleDelegator
    def self.wrap(collection)
      collection.map { |item| new(item) }
    end

    def mentor_name
      Teachers::Name.new(mentor_teacher).full_name
    end

    def mentee_name
      Teachers::Name.new(mentee_teacher).full_name
    end

    def mentor_single_line_summary
      single_line_summary(mentor_teacher)
    end

    def mentee_single_line_summary
      single_line_summary(mentee_teacher)
    end

    def formatted_started_on
      mentorship_period.started_on.to_fs(:govuk)
    end

    def formatted_finished_on
      return "" if mentorship_period.finished_on.blank?

      mentorship_period.finished_on.to_fs(:govuk)
    end

  private

    def mentorship_period
      __getobj__
    end

    def mentor_teacher
      @mentor_teacher ||= mentorship_period.mentor.teacher
    end

    def mentee_teacher
      @mentee_teacher ||= mentorship_period.mentee.teacher
    end

    def single_line_summary(teacher)
      "#{Teachers::Name.new(teacher).full_name} (#{formatted_started_on} - #{formatted_finished_on})"
    end
  end
end
