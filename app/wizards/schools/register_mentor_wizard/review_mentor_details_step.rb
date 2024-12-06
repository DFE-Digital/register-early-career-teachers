module Schools
  module RegisterMentorWizard
    class ReviewMentorDetailsStep < Step
      def next_step
        :email_address
      end
    end
  end
end
