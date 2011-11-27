$LOAD_PATH << '.'
$LOAD_PATH << './lib/'
# load gems
require 'rubygems'
require 'sinatra'

# load config and libs
require 'config'
require 'utils/rest'

# load models &controllers
require 'models'
require 'helpers'

get '/' do
  login_required  
  @sources = Source.all(:order => [:mg.asc])
  @shots = @user.latest_shots
  @stats = @user.stats_summary
  
  erb :index
end

