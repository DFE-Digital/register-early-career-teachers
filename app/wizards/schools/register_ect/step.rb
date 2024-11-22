# frozen_string_literal: true

module Schools
  module RegisterECT
    class Step < DfE::Wizard::Step
      include ActiveRecord::AttributeAssignment

      delegate :valid_step?, to: :wizard
      delegate :destroy_session, to: :store

      def next_step
      end

      def save!
        return false unless valid_step?

        persist
        true
      end

      def self.permitted_params
        []
      end

    private

      def fetch_trs_teacher(**args)
        ::TRS::APIClient.new.find_teacher(**args)
      rescue TRS::Errors::TeacherNotFound
        TRS::Teacher.new({})
      end

      def persist
        step_params.each { |key, value| store.set(key, value) }
      end

      def step_params
        wizard.step_params.to_h
      end
    end
  end
end
