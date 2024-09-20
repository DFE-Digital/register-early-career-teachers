module Authorisation
  extend ActiveSupport::Concern

  included do
    before_action :authorise
  end

  def authorise
    render "errors/unauthorised", status: :unauthorized unless authorised?
  end

  def authorised?
    false
  end
end
