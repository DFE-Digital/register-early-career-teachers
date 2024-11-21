module PersonasHelper
  class PersonasNotAvailableError < StandardError; end

  def appropriate_body_id_from_user_name(name)
    fail(PersonasNotAvailableError) unless Rails.application.config.enable_personas

    appropriate_bodies = AppropriateBody.pluck(:name, :id).to_h
    appropriate_body_name = appropriate_bodies.keys.find { |ab_name| Regexp.compile(ab_name) =~ name }
    appropriate_bodies[appropriate_body_name]
  end

  def persona_name(persona)
    split_persona_name(persona.name)[:name]
  end

  def persona_organisation(persona)
    split_persona_name(persona.name)[:org]
  end

  def persona_image(name, height: '150px')
    case
    when name.start_with?('Velma') then image_tag('personas/velma.png', height:)
    when name.start_with?('Fred') then image_tag('personas/fred.png', height:)
    when name.start_with?('Daphne') then image_tag('personas/daphne.png', height:)
    when name.start_with?('Norville') then image_tag('personas/shaggy.png', height:)
    end
  end

private

  def split_persona_name(name)
    name.match(/(?<name>.*)\ \((?<org>.*)\)/)
  end
end
