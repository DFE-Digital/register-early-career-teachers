module Schools
  class HomeController < SchoolsController
    layout "full"
    before_action :set_school

    def index
      teacher_service = Schools::Teacher.new(@school.id)
      @relationships = teacher_service.fetch_etcs_and_mentors
    end
  end
end
