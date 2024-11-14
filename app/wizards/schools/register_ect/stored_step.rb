# frozen_string_literal: true

module Schools
  module RegisterECT
    class StoredStep < DfE::Wizard::Step
      include ActiveRecord::AttributeAssignment

      delegate :valid_step?, to: :wizard
      delegate :destroy_session, to: :store

      def save!
        return false unless valid_step?

        handler = StepStoreHandlerFactory.create!(
          step_name: wizard.current_step_name,
          wizard:,
          store:,
          key:
        )
        handler.perform
      end

      def stored_attrs
        store
      end

    private

      def key
        model_name.param_key.to_sym
      end
    end
  end
end
