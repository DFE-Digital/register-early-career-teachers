class School::ECTService
  IN_PROGRESS = 'In progress'.freeze
  UNKNOWN = 'Unknown'.freeze

  def initialize(school_id)
    @school_id = school_id
  end

  def fetch_etcs_and_mentors
    ects_and_mentors.map do |ect|
      {
        ect: Teachers::Name.new(ect.teacher).full_name,
        mentor: Teachers::Name.new(ect.mentors.last&.teacher).full_name,
        status: ect_status(ect.teacher.id)
      }
    end
  end

private

  attr_reader :school_id

  def ects_and_mentors
    ECTAtSchoolPeriod
      .where(school: School.first)
      .eager_load(:teacher, mentors: :teacher)
      .merge(MentorshipPeriod.ongoing)
  end

  def ect_status(ect_id)
    ect_id.present? ? IN_PROGRESS : UNKNOWN
  end
end
