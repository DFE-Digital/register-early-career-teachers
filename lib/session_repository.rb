class SessionRepository
  def reset
    @session.delete(@form_key)
  end

  def update(args = {})
    args.each do |key, value|
      store[key.to_s] = value.is_a?(Hash) ? value.deep_stringify_keys : value
    end

    true
  end
  alias_method :update!, :update

private

  def initialize(session:, form_key:)
    @session = session
    @form_key = form_key
  end

  def get(key)
    store[key.to_s]
  end

  # Every missing methodname ending with '=' will call #update(name: args)
  # Otherwise call #get(name)
  def method_missing(name, *args)
    methodname = name.to_s
    methodname.ends_with?("=") ? update!(methodname[0..-2] => args.first) : get(name)
  end

  def respond_to_missing?(_, _)
    true
  end

  def store
    @session[@form_key] ||= {}
  end
end
