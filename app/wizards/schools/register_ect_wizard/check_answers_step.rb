module Schools
  module RegisterECTWizard
    class CheckAnswersStep < Step
      def next_step
        :confirmation
      end

    private

      def persist
        ect.register!
      end
    end
  end
end
