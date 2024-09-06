class PersonasController < ApplicationController
  skip_before_action :authenticate

  def index
    @personas = Persona.all
  end
end
