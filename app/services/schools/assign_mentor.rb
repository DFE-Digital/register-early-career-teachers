module Schools
  class AssignMentor

    attr_reader :ect, :mentor, :started_on

    def initialize(ect:, mentor:, started_on: Date.current)
      @ect = ect
      @mentor = mentor
      @started_on = started_on
    end

    def assign
      assign!
    rescue ActiveRecord::RecordInvalid
      false
    end

    def assign!
      ActiveRecord::Base.transaction do
        finish_current_mentorship!
        add_new_mentorship!
      end
    end

  private

    def add_new_mentorship!
      ect.mentorship_periods.create!(mentor:, started_on:)
    end

    def finish_current_mentorship!
      ect.current_mentorship&.finish!(finished_on: started_on)
    end
  end
end
