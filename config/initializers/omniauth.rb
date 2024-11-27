# add developer persona auth
Rails.application.config.middleware.use(OmniAuth::Builder) do
  provider(:developer,
           fields: %i[name email],
           uid_field: :email)

  dfe_sign_in_identifier = ENV['DFE_SIGN_IN_CLIENT_ID']
  dfe_sign_in_secret = ENV['DFE_SIGN_IN_SECRET']
  dfe_sign_in_redirect_uri = 'https://localhost:3001'
  dfe_sign_in_issuer_uri = ENV['DFE_SIGN_IN_ISSUER'].present? ? URI(ENV['DFE_SIGN_IN_ISSUER']) : nil

  provider(
    :openid_connect,
    callback_path: '/auth/dfe/callback',
    client_options: {
      host: dfe_sign_in_issuer_uri&.host,
      identifier: dfe_sign_in_identifier,
      port: dfe_sign_in_issuer_uri&.port,
      redirect_uri: dfe_sign_in_redirect_uri&.to_s,
      scheme: dfe_sign_in_issuer_uri&.scheme,
      secret: dfe_sign_in_secret,
    },
    discovery: true,
    issuer: ("#{dfe_sign_in_issuer_uri}:#{dfe_sign_in_issuer_uri.port}" if dfe_sign_in_issuer_uri.present?),
    name: :dfe,
    path_prefix: '/auth',
    response_type: :code,
    scope: %w[openid profile email organisation]
  )

  OmniAuth.config.logger = Rails.logger
end
