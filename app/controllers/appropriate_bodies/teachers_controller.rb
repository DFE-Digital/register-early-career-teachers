module AppropriateBodies
  class TeachersController < AppropriateBodiesController
    layout "full", only: :index

    def index
      # FIXME: find within the scope of the current AB

      @teachers = ::Teachers::Search.new(params[:q]).search
    end

    def show
      # FIXME: find within the scope of the current AB

      @teacher = Teacher.find_by!(trn: params[:trn])
    end
  end
end
