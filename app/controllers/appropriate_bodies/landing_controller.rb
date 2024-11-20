module AppropriateBodies
  class LandingController < AppropriateBodiesController
    skip_before_action :authorise,
                       :authenticate,
                       :set_appropriate_body,
                       only: :show

    def show = nil
  end
end
