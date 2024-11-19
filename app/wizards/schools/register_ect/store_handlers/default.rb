module Schools
  module RegisterECT
    module StoreHandlers
      class Default
        def initialize(wizard:, store:, key:)
          @wizard = wizard
          @store = store
          @key = key
        end

        def perform
          # store form data in the session
          store.store_attrs(key, step_params)
        end

      private

        attr_reader :wizard, :store, :key

        def step_params
          wizard.step_params.to_h
        end
      end
    end
  end
end
