module Admin
  class TeachersController < AdminController
    layout "full"

    def index
      @pagy, teachers = pagy(Teachers::Search.new(params[:q]).search.order(:last_name, :first_name, :id))
      @teachers = TeacherPresenter.wrap(teachers)
    end

    def show
      @page = params[:page] || 1
      @teacher = TeacherPresenter.new(Teacher.find_by(trn: params[:id]))
    end
  end
end
