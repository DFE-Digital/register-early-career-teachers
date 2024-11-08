module AppropriateBodies
  class TeachersController < AppropriateBodiesController
    def show
      # FIXME: find within the scope of the current AB

      @teacher = Teacher.find_by!(trn: params[:trn])
    end
  end
end
