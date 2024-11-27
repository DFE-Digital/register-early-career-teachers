module PersonasHelper
  class PersonasNotAvailableError < StandardError; end

  def appropriate_body_id_from_user_name(name)
    fail(PersonasNotAvailableError) unless Rails.application.config.enable_personas

    appropriate_bodies = AppropriateBody.pluck(:name, :id).to_h
    appropriate_body_name = appropriate_bodies.keys.find { |ab_name| Regexp.compile(ab_name) =~ name }
    appropriate_bodies[appropriate_body_name]
  end

  def school_id_from_user_name(name)
    fail(PersonasNotAvailableError) unless Rails.application.config.enable_personas

    school_ids = GIAS::School.joins(:school).pluck('gias_schools.name', 'schools.id').to_h
    name_of_school = school_ids.keys.find { |school_name| Regexp.compile(school_name) =~ name }
    school_ids[name_of_school]
  end

  def persona_name(persona)
    split_persona_name(persona.name)[:name]
  end

  def persona_organisation(persona)
    split_persona_name(persona.name)[:org]
  end

  def persona_user_type(persona)
    split_persona_name(persona.name)[:persona_type]
  end

  def persona_image(name, height: '150px')
    case
    when name.start_with?('Velma')
      image_tag('personas/velma.png', height:, alt: 'Velma from Scooby Doo wearing an orange turtleneck jumper.')
    when name.start_with?('Fred')
      image_tag('personas/fred.png', height:, alt: 'Fred from Scooby Doo. He is shrugging and wearing a white top with a red cravat.')
    when name.start_with?('Daphne')
      image_tag('personas/daphne.png', height:, alt: 'Daphne from Scooby Doo looking quizzical in a purple dress.')
    when name.start_with?('Norville')
      image_tag('personas/shaggy.png', height:, alt: 'Shaggy from Scooby Doo, wearing a green shirt looking directly forwards.')
    when name.start_with?('Bob')
      image_tag('personas/bob.png', height:, alt: "Bob from Bob's Burgers, holding a hamburger")
    when name.start_with?('Serena')
      image_tag('personas/serena.png', height:, alt: 'Serena from Sailor Moon leaping in the air.')
    end
  end

private

  def split_persona_name(name)
    match = name.match(/(?<name>.*)\ \((?<org>.*)\)/)

    return nil unless match

    org = match[:org]
    persona_type = case org
                   when /School$/i
                     'School user'
                   when /Associate Body$/i
                     'Appropriate body user'
                   end

    { name: match[:name], org:, persona_type: }
  end
end
