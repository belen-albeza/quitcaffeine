require 'sinatra'
require 'user_settings/model'
require 'source/model'

get '/settings' do
  login_required  
  @settings = @user.user_settings
  @sources = Source.all(:order => [:mg.asc])
  
  erb :user_settings
end

post '/settings' do
  login_required
  @user.user_settings.update_with_form(params)  
  
  redirect settings_url, :notice => 'Updated settings'
end