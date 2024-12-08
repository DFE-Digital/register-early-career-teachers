class Personas::AppropriateBodySessionsController < ApplicationController
  skip_before_action :authenticate

  def show
    @appropriate_bodies = AppropriateBody.all
  end

  def update
    @appropriate_body = AppropriateBody.find(params[:appropriate_body_id])
    current_user.set_appropriate_body_id!(@appropriate_body.id)
    redirect_to appropriate_body_sessions_path, notice: "Appropriate body set to #{@appropriate_body.name}"
  end
end
