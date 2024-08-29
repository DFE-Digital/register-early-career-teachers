class CountriesController < ApplicationController
  def index
  end

  def show
    @country = params[:id].titleize
  end

  def create
    redirect_to country_path(id: params["input-autocomplete"].parameterize)
  end
end
