module Schools
  module RegisterMentor
    class CheckAnswersStep < Step
      def next_step
        :confirmation
      end

    private

      def persist
        mentor.register!
      end
    end
  end
end
