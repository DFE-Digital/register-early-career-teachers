class AppropriateBodiesController < ApplicationController
  include Authorisation

  before_action :set_appropriate_body

private

  def set_appropriate_body
    @appropriate_body = AppropriateBody.find(current_user.appropriate_body_id)
  end

  def authorised?
    # FIXME: make this work with DfE Sign-in

    current_user
  end
end
