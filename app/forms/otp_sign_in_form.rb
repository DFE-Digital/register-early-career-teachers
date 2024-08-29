class OTPSignInForm
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment
  include ActiveModel::Serialization

  attr_accessor :email, :code

  validates :email, presence: true, notify_email: true
  validate :code_is_verified, on: :verify

  def attributes
    { email:, code: }
  end

  def generate_and_email_code_to_user!
    otp.generate_and_send_code
  end

  def user
    @user ||= User.find_by(email:)
  end

private

  def code_is_verified
    # prevent leaking info when the email doesn't exist
    errors.delete(:email)

    errors.add(:code, "Enter the 6-digit code from the email") and return unless code =~ /\A\d{6}\z/

    errors.add(:code, "The code entered is invalid") unless user && otp.verify(code:)
  end

  def otp
    @otp ||= OneTimePassword.new(user:)
  end
end
