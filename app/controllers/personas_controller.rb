class PersonasController < ApplicationController
  skip_before_action :authenticate
  layout 'full'

  def index
    persona_data = Struct.new(:name, :email, :school, :image, :alt, :appropriate_body, :dfe_staff, :type) do
      def appropriate_body_id
        (appropriate_body.present?) ? AppropriateBody.find_by!(name: appropriate_body).id : nil
      end

      def school_urn
        (school.present?) ? School.joins(:gias_school).find_by!(gias_school: { name: school }).urn : nil
      end

      def user_id
        dfe_staff ? User.find_by!(name:).id : nil
      end
    end

    @personas = YAML.load_file(Rails.root.join('config/personas.yml'))
                    .map { |p| persona_data.new(**p.symbolize_keys) }
  end
end
