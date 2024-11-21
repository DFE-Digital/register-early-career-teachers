# frozen_string_literal: true

class FormData::DataStore
  def initialize(session:, form_key:)
    @session = session
    @form_key = form_key
  end

  def store
    session[form_key] ||= {}
  end

  def set(key, value)
    store[key.to_s] = value.is_a?(Hash) ? value.deep_stringify_keys : value
  end

  def get(key)
    store[key.to_s]
  end

  def clean
    @session[@form_key] = {}
  end

  def destroy
    @session.delete(@form_key)
  end

private

  attr_reader :session, :form_key
end
