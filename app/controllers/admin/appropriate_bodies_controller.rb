module Admin
  class AppropriateBodiesController < AdminController
    include Pagy::Backend

    def index
      @pagy, @appropriate_bodies = pagy(
        AppropriateBodies::Search.new(params[:q]).search,
        limit: 30
      )
    end
  end
end
