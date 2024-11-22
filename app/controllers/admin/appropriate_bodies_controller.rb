module Admin
  class AppropriateBodiesController < AdminController
    include Pagy::Backend

    layout 'full'

    def index
      @pagy, @appropriate_bodies = pagy(
        AppropriateBodies::Search.new(params[:q]).search,
        limit: 30
      )
    end
  end
end
