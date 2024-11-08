module PersonasHelper
  class PersonasNotAvailableError < StandardError; end

  def appropriate_body_id_from_user_name(name)
    fail(PersonasNotAvailableError) unless Rails.application.config.enable_personas

    appropriate_bodies = AppropriateBody.pluck(:name, :id).to_h
    appropriate_body_name = appropriate_bodies.keys.find { |ab_name| Regexp.compile(ab_name) =~ name }
    appropriate_bodies[appropriate_body_name]
  end
end
