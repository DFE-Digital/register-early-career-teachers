# frozen_string_literal: true

module Schools
  module RegisterMentor
    class ReviewMentorDetailsStep < Step
      def next_step
        :email_address
      end
    end
  end
end
