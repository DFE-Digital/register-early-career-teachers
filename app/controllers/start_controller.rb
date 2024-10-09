# frozen_string_literal: true

class StartController < ApplicationController
  skip_before_action :authenticate
end
