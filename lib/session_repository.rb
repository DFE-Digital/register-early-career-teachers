class SessionRepository
  def set(key, value)
    store[key.to_s] = value.is_a?(Hash) ? value.deep_stringify_keys : value
  end

  def reset
    @session.delete(@form_key)
  end

private

  def initialize(session:, form_key:)
    @session = session
    @form_key = form_key
  end

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
