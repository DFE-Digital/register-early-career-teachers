# frozen_string_literal: true

module Schools
  class RegisterECTController < ApplicationController
    before_action :initialize_wizard, only: %i[new create]
    before_action :reset_session, only: :new

    FORM_KEY = :register_ect_wizard
    WIZARD_CLASS = Schools::RegisterECT::BaseWizard.freeze

    def start
    end

    def new
      @ect = Schools::TeacherPresenter.new(**@wizard.stored_attrs)

      render current_step
    end

    def create
      if @wizard.save!
        redirect_to @wizard.next_step_path
      else
        render current_step
      end
    end

  private

    def initialize_wizard
      @wizard = WIZARD_CLASS.new(
        current_step:,
        step_params:,
        store:
      )
    end

    def store
      @store ||= FormData::WizardStepStore.new(session:, form_key: FORM_KEY)
    end

    def current_step
      step_from_path = request.path.split("/").last.underscore.to_sym
      return :not_found if WIZARD_CLASS.steps.first.keys.exclude?(step_from_path)

      step_from_path
    end

    def step_params
      return default_params if params[current_step].blank?

      params
    end

    def default_params
      ActionController::Parameters.new({ current_step => params })
    end

    def reset_session
      return if current_step != :find_ect

      @wizard.destroy_session
    end
  end
end
