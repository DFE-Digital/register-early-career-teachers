class User < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, notify_email: true

  # TODO: we can encrypt the secret in the DB but we need to set up keys first
  # encrypts :otp_secret

  # Associations
  has_many :dfe_roles

  # Instance Methods
  # FIXME: delete this, should be handled by Sessions::SessionUser
  def dfe_user?
    dfe_roles.any?
  end
end
