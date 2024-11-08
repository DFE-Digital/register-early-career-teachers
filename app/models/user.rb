class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, notify_email: true

  # TODO: we can encrypt the secret in the DB but we need to set up keys first
  # encrypts :otp_secret
  has_many :dfe_roles
end
