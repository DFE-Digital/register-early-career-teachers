# frozen_string_literal: true

module Schools
  class RegisterMentorController < ApplicationController
    before_action :initialize_wizard, only: %i[new create]
    before_action :reset_wizard, only: :new

    FORM_KEY = :register_mentor_wizard
    WIZARD_CLASS = Schools::RegisterMentor::Wizard.freeze

    def start
      @ect_name = params[:ect_name]
    end

    def new
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
        step_params: params,
        store: SessionRepository.new(session:, form_key: FORM_KEY)
      )
      @mentor = @wizard.mentor
    end

    def current_step
      request.path.split("/").last.underscore.to_sym.tap do |step_from_path|
        return :not_found unless WIZARD_CLASS.step?(step_from_path)
      end
    end

    def reset_wizard
      @wizard.reset if current_step == :find_mentor
    end
  end
end
