require 'sinatra'
require 'user/twitter'
require 'user/model'

get '/logout' do
  session.clear
  redirect '/'
end

get '/twitter/connect' do
  twitter = Social::Twitter.new(settings.twitter_config, session)  
  redirect twitter.get_auth_url(session)
end

get '/twitter/callback' do
  twitter = Social::Twitter.new(settings.twitter_config, session)
  if twitter.authenticate!(session)
    redirect '/'
  else
    status 403
    'Twitter authentication failed'
  end
end

get '/profile/:username' do
  @profile_user = User.first(:username => params[:username])
  if @profile_user.nil?  
    raise Sinatra::NotFound    
  end
  
  @shots = @profile_user.latest_shots
  @stats = @profile_user.full_stats
  
  erb :profile    
end