$LOAD_PATH << '.'
$LOAD_PATH << './lib/'
# load gems
require 'rubygems'
require 'sinatra'
require 'rack-flash'
require 'sinatra/redirect_with_flash'

# load config and libs
require 'config'

# load models &controllers
require 'models'
require 'helpers'

use Rack::Flash

get '/' do
  if @user
    @sources = Source.all(:order => [:mg.asc])
    @shots = @user.latest_shots
    @stats = @user.stats_summary
    template = :index
  else
    @max_users = settings.max_users
    template = :anonymous
  end
  
  erb template
end

get '/about' do
  redirect '/', :notice => 'Waka waka eh eh'
end

