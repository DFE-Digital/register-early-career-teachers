module Admin
  class TeachersController < AdminController
    layout "full"

    def index
      @pagy, @teachers = pagy(Teachers::Search.new(params[:q]).search.order(:last_name, :first_name, :id))
    end

    def show
      @page = params[:page] || 1
      @teacher = TeacherPresenter.new(Teacher.find_by(trn: params[:id]))
      @ect_periods = SchoolPeriodPresenter.wrap(@teacher.ect_at_school_periods.order(started_on: :desc)) if @teacher.ect?
      @mentor_periods = SchoolPeriodPresenter.wrap(@teacher.mentor_at_school_periods.order(started_on: :desc)) if @teacher.mentor?
    end
  end
end
