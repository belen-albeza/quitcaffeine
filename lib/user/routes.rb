require 'sinatra'
require 'user/twitter'
require 'user/model'
  
get '/login' do 
  # redirect '/' if user
  erb :login
end    

get '/twitter/connect' do
  twitter = Social::Twitter.new(settings.twitter_config, session)  
  redirect twitter.get_auth_url(session)
end

get '/twitter/callback' do
  twitter = Social::Twitter.new(settings.twitter_config, session)
  if twitter.authenticate!(session)
    # TODO: tie twitter user to our user
    redirect '/'
  else
    status 403
    'Twitter authentication failed'
  end
end

get '/profile/:username' do
  puts params[:username]
  @profile_user = User.first(:username => params[:username])
  if @profile_user.nil?  
    raise Sinatra::NotFound    
  else
    erb :profile    
  end
end