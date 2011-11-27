require 'sinatra'
require 'user_settings/model'
require 'source/model'

get '/settings' do
  login_required  
  @settings = @user.user_settings
  @sources = Source.all(:order => [:mg.asc])
  puts @settings.enable_tweets
  puts @settings.enable_public_profile
  puts @settings.source_to_track
  
  erb :user_settings
end

post '/settings' do
  login_required
  @user.user_settings.update_with_form(params)  
  
  redirect show_settings_url
end