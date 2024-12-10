class AdminController < ApplicationController
  include Authorisation

  def index
  end

private

  def authorised?
    true
  end
end
