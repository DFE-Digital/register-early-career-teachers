module PersonasHelper
  class UnrecognisedPersonaType < StandardError; end

  def persona_organisation(persona)
    case persona.type
    when 'School user'
      persona.school
    when 'Appropriate body user'
      persona.appropriate_body
    when 'DfE staff'
      'Department for Education staff member'
    else
      fail(UnrecognisedPersonaType)
    end
  end
end
