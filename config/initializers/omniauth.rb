# add developer persona auth
Rails.application.config.middleware.use(OmniAuth::Builder) do
  if Rails.application.config.enable_personas
    provider(
      :developer,
      name: 'developer',
      # FIXME: add appropriate_body_id and school_urn to fields
      fields: %i[name email],
      uid_field: :email
    )
  end

  if Rails.application.config.dfe_sign_in_enabled
    issuer_uri = URI(Rails.application.config.dfe_sign_in_issuer)

    provider(
      :openid_connect,
      callback_path: '/auth/dfe/callback',
      client_options: {
        host: issuer_uri.host,
        identifier: Rails.application.config.dfe_sign_in_client_id,
        port: issuer_uri.port,
        redirect_uri: Rails.application.config.dfe_sign_in_redirect_uri,
        scheme: issuer_uri.scheme,
        secret: Rails.application.config.dfe_sign_in_secret,
      },
      discovery: true,
      issuer: "#{issuer_uri}:#{issuer_uri.port}",
      name: 'dfe_sign_in',
      path_prefix: '/auth',
      response_type: :code,
      scope: %w[openid profile email organisation]
    )
  end

  OmniAuth.config.logger = Rails.logger
end
