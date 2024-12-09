module Teachers
  module Extensions
    class CreateExtension
      attr_reader :teacher, :params, :extension

      def initialize(teacher, params)
        @teacher = teacher
        @params = params
      end

      def create_extension
        @extension = teacher.induction_extensions.build(params)
        @extension.save
      end
    end
  end
end
