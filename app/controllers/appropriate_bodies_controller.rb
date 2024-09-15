class AppropriateBodiesController < ApplicationController
  before_action :set_appropriate_body

  def set_appropriate_body
    # FIXME: retrieve the current_user's AB
    @appropriate_body = AppropriateBody.first
  end
end
