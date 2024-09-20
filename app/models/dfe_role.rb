class DfERole < ApplicationRecord
  # TODO: Is this right?
  ROLE_PRECEDENCE = %w[super_admin finance admin].freeze

  belongs_to :user
end
