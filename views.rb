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
  @shots = @user.shots(:order => [:created_at.desc])
  puts @shots
  erb :index
end

