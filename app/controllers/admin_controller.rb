class AdminController < ApplicationController
  include Authorisation

  def index
  end

private

  def authorised?
    Admin::Access.new(current_user).can_access?
    # true
  end
end
