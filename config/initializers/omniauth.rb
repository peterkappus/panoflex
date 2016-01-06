Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {
    :provider_ignores_state => true,
    #insane I had to do this... (found after hours of mucking around)
    #https://github.com/zquestz/omniauth-google-oauth2/issues/181#issuecomment-114635065
    setup: (lambda do |env|
      request = Rack::Request.new(env)
      env['omniauth.strategy'].options['token_params'] = {}
    end)
    }
end
