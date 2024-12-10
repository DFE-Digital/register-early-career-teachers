module AppropriateBodies
  class TeachersController < AppropriateBodiesController
    layout "full", only: :index

    def index
      @teachers = ::Teachers::Search.new(
        query_string: params[:q],
        appropriate_body: @appropriate_body
      ).search
    end

    def show
      @teacher = AppropriateBodies::CurrentTeachers.new(@appropriate_body).current.find_by!(trn: params[:trn])

      @current_induction_period = @teacher.induction_periods.find_by!(finished_on: nil)
      @past_induction_periods = @teacher.induction_periods.where.not(finished_on: nil)
    end
  end
end
