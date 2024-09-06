# add developer persona auth
Rails.application.config.middleware.use(OmniAuth::Builder) do
  provider(:developer,
           fields: %i[name email],
           uid_field: :email)
end
