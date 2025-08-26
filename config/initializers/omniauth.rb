Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :developer unless Rails.env.production? # You should replace it with your provider
  provider :google_oauth2,
         Rails.application.credentials.dig(:google, :client_id),
         Rails.application.credentials.dig(:google, :client_secret),
         { scope: "email,profile" }
  provider :facebook,
         Rails.application.credentials.dig(:facebook, :app_id),
         Rails.application.credentials.dig(:facebook, :app_secret),
         scope: 'email', info_fields: 'email,name'
  provider :twitter,
           Rails.application.credentials.dig(:twitter, :api_key),
           Rails.application.credentials.dig(:twitter, :api_secret)
  provider :linkedin,
           Rails.application.credentials.dig(:linkedin, :client_id),
           Rails.application.credentials.dig(:linkedin, :client_secret),
           scope: "r_liteprofile r_emailaddress"
end
OmniAuth.config.allowed_request_methods = [:post, :get]
