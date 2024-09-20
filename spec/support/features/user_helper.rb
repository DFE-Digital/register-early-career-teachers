# frozen_string_literal: true

module UserHelper
  def sign_in_as(user)
    page.goto(otp_sign_in_path)
    page.get_by_label('Email address').type(user.email)
    page.get_by_role("button", name: 'Request code to sign in').click
    page.get_by_label('Sign in code').type(ROTP::TOTP.new(user.reload.otp_secret, issuer: "ECF2").now)
    page.get_by_role("button", name: 'Sign in').click
  end

  def sign_in_as_admin
    FactoryBot.create(:user, email: "admin@example.com", name: "Admin User").tap do |user|
      sign_in_as(user)
    end
  end

  def sign_out
    page.goto(otp_sign_out_path)
  end
end

RSpec.configure do |config|
  config.include UserHelper, type: :feature
end
