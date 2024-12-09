module AppropriateBodies
  module Teachers
    class ExtensionsController < AppropriateBodiesController
      def index
        @teacher = find_teacher
      end

      def new
        @teacher = find_teacher
        @extension = @teacher.induction_extensions.build
      end

      def create
        @teacher = find_teacher
        @extension = @teacher.induction_extensions.build(extension_params)

        create_service = ::Teachers::Extensions::CreateExtension.new(@teacher, extension_params)
        if create_service.create_extension
          redirect_to ab_teacher_path(@teacher), notice: "Extension was successfully added."
        else
          @extension = create_service.extension
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        @teacher = find_teacher
        @extension = @teacher.induction_extensions.find(params[:id])
      end

      def update
        @teacher = find_teacher
        @extension = @teacher.induction_extensions.find(params[:id])

        update_service = ::Teachers::Extensions::UpdateExtension.new(@extension, extension_params)

        if update_service.update_extension
          redirect_to ab_teacher_path(@teacher), notice: "Extension was successfully updated."
        else
          @extension = update_service.extension
          render :edit, status: :unprocessable_entity
        end
      end

    private

      def find_teacher
        AppropriateBodies::CurrentTeachers.new(@appropriate_body).current.find_by!(trn: params[:teacher_trn])
      end

      def extension_params
        params.require(:induction_extension).permit(:number_of_terms)
      end
    end
  end
end
