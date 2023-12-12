Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '486452571803-mltujbedh41q37kl58mamng8d0ajklph.apps.googleusercontent.com', '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',
           {
             scope: 'email, profile',
             prompt: 'select_account',
             image_aspect_ratio: 'square',
             image_size: 50
           }
end
OmniAuth.config.allowed_request_methods = %i[get]
# OmniAuth.config.allowed_request_methods = %i[get put post]
# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
# end
