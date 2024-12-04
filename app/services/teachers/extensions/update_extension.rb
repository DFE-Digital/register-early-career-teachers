module Teachers
  module Extensions
    class UpdateExtension
      attr_reader :extension, :params

      def initialize(extension, params)
        @extension = extension
        @params = params
      end

      def update_extension
        extension.update(params)
      end
    end
  end
end
