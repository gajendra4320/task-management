Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '486452571803-9rov7ckdr30ck5l965pbi8da1db5p40m.apps.googleusercontent.com', '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',
           {
             scope: 'email, profile',
             prompt: 'select_account',
             image_aspect_ratio: 'square',
             image_size: 50
           }
end
# OmniAuth.config.allowed_request_methods = %i[get put post]
# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
# end
