$LOAD_PATH << '.'
$LOAD_PATH << './lib/'
# load gems
require 'rubygems'
require 'sinatra'
# load everything else
require 'sinatra-twitter-oauth'
require 'utils/rest'

# config
configure do
  # twitter stuff
  twitter_config = {
    :key => 'HISsvHGwQkGIo8mYJwu5ng',
    :secret   => 'mGbZybtbw4S0EqxooSead565HAIaoFs63pOMVPSM',
    :callback => 'http://lab.belenalbeza.com:4567/twitter/callback',
    :login_template => {
      :erb => :login_template
    }     
  }
  
  set('twitter_oauth_config', twitter_config)
end

enable :sessions

get '/' do
  login_required
  erb :index
end

get '/twitter/callback' do
  # TODO: tie twitter user with our own
  if authenticate!
    redirect '/'
  else
    status 403
    'Not Authenticated'
  end
end