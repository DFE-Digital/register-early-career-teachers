# frozen_string_literal: true

module Schools
  module RegisterECT
    class StoredStep < DfE::Wizard::Step
      include ActiveRecord::AttributeAssignment

      delegate :valid_step?, to: :wizard
      def save!
        return false unless valid_step?

        if wizard.current_step_name == :find_ect
          store.store_attrs(key, trs_teacher)
        elsif wizard.current_step_name == :review_ect_details
          true
        else
          store.store_attrs(key, step_params)
        end
      end

      def stored_attrs
        store
      end

    private

      def key
        model_name.param_key
      end

      def step_params
        wizard.step_params.to_h
      end

      def trs_teacher
        trn = @wizard.current_step.trn
        date_of_birth = @wizard.current_step.date_of_birth

        trs_teacher = ::TRS::APIClient.new.find_teacher(trn:, date_of_birth: format(date_of_birth))

        {
          trn: trs_teacher.trn,
          first_name: trs_teacher.first_name,
          last_name: trs_teacher.last_name,
          date_of_birth: trs_teacher.date_of_birth
        }.freeze
      end

      def format(date_of_birth)
        "#{date_of_birth[1]}/#{date_of_birth[2]}/#{date_of_birth[3]}"
      end
    end
  end
end
