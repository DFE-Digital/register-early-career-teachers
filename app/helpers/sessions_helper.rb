module SessionsHelper
  def login_options
    options = [govuk_link_to("Sign-in with a one time password", otp_sign_in_path, no_visited_state: true)]

    if Rails.application.config.enable_personas
      options << govuk_link_to("Sign-in with a persona", personas_path, no_visited_state: true)
    end

    options
  end
end
