module Schools
  class RegisterECT
    attr_reader :first_name, :last_name, :school_urn, :started_on, :teacher, :trn

    def initialize(first_name:, last_name:, trn:, school_urn:, started_on: Date.current)
      @first_name = first_name
      @last_name = last_name
      @school_urn = school_urn
      @started_on = started_on
      @trn = trn
    end

    def register_teacher!
      ActiveRecord::Base.transaction do
        create_teacher!
        start_at_school!
      end
    end

  private

    def create_teacher!
      @teacher = ::Teacher.create!(first_name:, last_name:, trn:)
    end

    def school
      @school ||= School.find_by(urn: school_urn)
    end

    def start_at_school!
      teacher.ect_at_school_periods.create!(school:, started_on:)
    end
  end
end
