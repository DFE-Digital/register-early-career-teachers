class AppropriateBodiesController < ApplicationController
  include Authorisation

  before_action :set_appropriate_body

private

  def set_appropriate_body
    @appropriate_body = current_user.appropriate_bodies.find(params[:id])
  end

  def authorised?
    current_user.appropriate_bodies.any?
  end
end
