# frozen_string_literal: true

module FormData
  class WizardStepStore < DataStore
    def store_attrs(step, attrs)
      set(step, attrs)
    end

    def attrs_for(step)
      get(step) || {}
    end

    def stored_attrs
      store
    end

    def destroy_session
      destroy
    end
  end
end
