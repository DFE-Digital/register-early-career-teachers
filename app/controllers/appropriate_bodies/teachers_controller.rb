module AppropriateBodies
  class TeachersController < AppropriateBodiesController
    def show
      # FIXME: find within the scope of the current AB

      @teacher = Teacher.find(params[:id])
    end
  end
end
