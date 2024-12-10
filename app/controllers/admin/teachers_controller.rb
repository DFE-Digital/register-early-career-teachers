module Admin
  class TeachersController < AdminController
    layout "full"

    def index
      @appropriate_bodies = AppropriateBody.order(:name)
      @pagy, @teachers = pagy(
        Teachers::Search.new(
          query_string: params[:q],
          appropriate_body_ids: params[:appropriate_body_ids]
        ).search
      )
    end

    def show
      @page = params[:page] || 1
      @teacher = TeacherPresenter.new(Teacher.find_by(trn: params[:id]))
      @ect_periods = SchoolPeriodPresenter.wrap(@teacher.ect_at_school_periods.order(started_on: :desc)) if @teacher.ect?
      @mentor_periods = SchoolPeriodPresenter.wrap(@teacher.mentor_at_school_periods.order(started_on: :desc)) if @teacher.mentor?
    end
  end
end
