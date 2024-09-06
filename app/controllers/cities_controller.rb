class CitiesController < ApplicationController
  skip_before_action :authenticate

  def index
  end

  def show
    @city = params[:id].titleize
  end

  def create
    redirect_to city_path(id: params["name"].parameterize)
  end
end
