module Admin
  class RolesForm
    include ActiveModel::Model

    ROLE_TYPES = %w[appropriate_body delivery_partner lead_provider school].freeze

    attr_accessor :role_type, :user
    attr_writer :role_ids

    validates :role_type, inclusion: { in: ROLE_TYPES }
    validates :user, presence: true

    def collection_for_role_type
      role_type_class.all
    end

    def save!
      roleables = role_ids.compact_blank.map do |role_id|
        role_type_class.find(role_id)
      end
      user.send("#{role_type.pluralize}=", roleables)
    end

    def role_ids
      @role_ids ||= user.send(role_type.pluralize).map(&:id)
    end

  private

    def role_type_class
      role_type.classify.constantize
    end
  end
end
