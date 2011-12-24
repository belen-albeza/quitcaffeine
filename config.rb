require 'dalli'

if (ENV['RACK_ENV'] == 'production') and ENV['RESTRICTED']
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    [username, password] == [ENV['AUTH_USER'] || 'hola', ENV['AUTH_PASS'] || 'feo']
  end
end

# config
configure do
  set :cache, Dalli::Client.new
  set :enable_cache, true
  set :ttl_5mins, 300
  set :ttl_1hour, 3600
  set :max_users, 50
  
  set(:twitter_config, {
    :key => 'key',
    :secret => 'secret',
    :callback_url => ENV['TWITTER_CALLBACK'] || 'http://0.0.0.0:4567/twitter/callback'
  })
  
  set :session_secret, ENV['SESSION_KEY'] || '1234'
end

enable :sessions
