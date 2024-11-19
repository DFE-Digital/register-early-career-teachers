class PagesController < ApplicationController
  skip_before_action :authenticate

  def home
    redirect_to(login_redirect_path) if authenticated?
  end

  def support
  end
end
