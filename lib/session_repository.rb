class SessionRepository
  def initialize(session:, form_key:)
    @session = session
    @form_key = form_key
  end

  def set(key, value)
    store[key.to_s] = value.is_a?(Hash) ? value.deep_stringify_keys : value
  end

  def clean
    @session[@form_key] = {}
  end

  def destroy
    @session.delete(@form_key)
  end
  alias_method :destroy_session, :destroy

private

  delegate :key?, to: :store, private: true

  def get(key)
    store[key.to_s]
  end

  def method_missing(name, *_args)
    get(name)
  end

  def respond_to_missing?(_, _)
    true
  end

  def store
    @session[@form_key] ||= {}
  end
end
