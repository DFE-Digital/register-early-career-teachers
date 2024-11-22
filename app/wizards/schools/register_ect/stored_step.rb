# frozen_string_literal: true

module Schools
  module RegisterECT
    class StoredStep < DfE::Wizard::Step
      include ActiveRecord::AttributeAssignment

      delegate :valid_step?, to: :wizard
      delegate :destroy_session, to: :store

      def next_step
      end

      def save!
        return false unless valid_step?

        perform
        true
      end

      def stored_attrs
        store
      end

      def self.permitted_params
        []
      end

    private

      def perform
        step_params.each { |key, value| store.set(key, value) }
      end

      def step_params
        wizard.step_params.to_h
      end
    end
  end
end
