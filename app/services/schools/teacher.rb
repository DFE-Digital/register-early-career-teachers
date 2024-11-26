module Schools
  class Teacher
    IN_PROGRESS = 'In progress'.freeze
    UNKNOWN = 'Unknown'.freeze

    def initialize(school_id)
      @school_id = school_id
    end

    def fetch_etcs_and_mentors
      ects_and_mentors.map do |ect|
        {
          ect_name: ::Teachers::Name.new(ect.teacher).full_name,
          ect_trn: ect.teacher.trn,
          mentor_name: ::Teachers::Name.new(ect.mentors.last&.teacher).full_name,
          status: ect_status(ect.teacher.id)
        }
      end
    end

  private

    attr_reader :school_id

    def ects_and_mentors
      ECTAtSchoolPeriod
        .where(school:)
        .eager_load(:teacher, mentors: :teacher)
        .merge(MentorshipPeriod.ongoing)
    end

    def ect_status(ect_id)
      ect_id.present? ? IN_PROGRESS : UNKNOWN
    end

    def school
      @school ||= School.find_by(id: school_id) || School.first
    end
  end
end
