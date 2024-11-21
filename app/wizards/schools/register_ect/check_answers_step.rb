module Schools
  module RegisterECT
    class CheckAnswersStep < StoredStep
      def next_step
        :confirmation
      end
    end
  end
end
