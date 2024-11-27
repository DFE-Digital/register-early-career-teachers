module AppropriateBodies
  module Teachers
    class ExtensionsController < AppropriateBodiesController
      def index
        @teacher = find_teacher
      end

    private

      def find_teacher
        AppropriateBodies::CurrentTeachers.new(@appropriate_body).current.find_by!(trn: params[:teacher_trn])
      end
    end
  end
end
