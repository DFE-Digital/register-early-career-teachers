class AppropriateBodiesController < ApplicationController
  include Authorisation

  before_action :set_appropriate_body
  layout "full", only: :show

  def show
    # FIXME: find within the scope of the current AB

    @teachers = Teachers::Search.new(params[:q]).search
  end

private

  def set_appropriate_body
    @appropriate_body = AppropriateBody.find(session[:appropriate_body_id])
  end

  def authorised?
    # FIXME: make this work with DfE Sign-in

    current_user
  end
end
