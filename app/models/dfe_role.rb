class DfERole < ApplicationRecord
  ROLE_PRECEDENCE = %w[super_admin finance admin].freeze

  belongs_to :user

  validates :user_id, presence: { message: "Choose a user" }
end
