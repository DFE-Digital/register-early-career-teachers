class PersonasController < ApplicationController
  skip_before_action :authenticate
  layout 'full'

  def index
    @personas = Persona.all
  end
end
