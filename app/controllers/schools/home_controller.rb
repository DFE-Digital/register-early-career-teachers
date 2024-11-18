module Schools
  class HomeController < ApplicationController
    layout "full"

    def index
      throw new Error("Something blew up")

      ab = AppropriateBody.find(999999999)
      teacher_service = Schools::Teacher.new(school[:id])
      @school_name = school[:name]
      @relationships = teacher_service.fetch_etcs_and_mentors
    end

  private

    def school
      # This is temporary. 'School' will be set once DfE signin hooked up
      @school ||= School.joins(:gias_school)
                        .select("schools.id, gias_schools.name")
                        .first
    end
  end
end
