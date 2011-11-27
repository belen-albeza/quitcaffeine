require 'sinatra'
require 'user/twitter'

helpers do
  def login_required
    twitter = Social::Twitter.new(settings.twitter_config, session)
    tw_screen_name = session[:tw_screen_name]

    unless tw_screen_name.nil?
      @user = User.get_or_create(tw_screen_name)
      session[:user_id] = @user.id
    else
      @user = nil
      redirect '/login'
    end
  end
end