class AdminController < ApplicationController
  include Authorisation

  def index
  end

private

  def authorised?
    current_user&.dfe_user?
  end
end
