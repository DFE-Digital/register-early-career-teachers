FactoryBot.define do
  factory(:session_repository) do
    initialize_with { new(session: {}, form_key: :main) }
  end
end
