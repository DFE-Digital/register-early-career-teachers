class Persona < User
  default_scope { where("email ilike '%@example.com'") }
end
