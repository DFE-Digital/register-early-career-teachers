module Schools
  module RegisterECT
    class CheckAnswersStep < Step
      def next_step
        :confirmation
      end

    private

      def persist
        ect.create_teacher!
      end
    end
  end
end
