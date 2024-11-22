module Schools
  module RegisterECT
    class CheckAnswersStep < Step
      def next_step
        :confirmation
      end
    end
  end
end
