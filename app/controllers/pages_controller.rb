class PagesController < ApplicationController
  skip_before_action :authenticate

  def home
    redirect_to(login_redirect_path) and return if authenticated?

    redirect_to(ab_landing_path) unless Rails.application.config.enable_schools_interface
  end

  def support
  end
end
