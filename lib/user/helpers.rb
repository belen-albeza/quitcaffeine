require 'sinatra'
require 'user/twitter'

helpers do
  def login_required
    twitter = Social::Twitter.new(settings.twitter_config, session)
    user_info = session[:tw_user_info]

    if user_info
      @user = User.get_or_create(user_info['screen_name'])
      session[:user_id] = @user.id
    else
      @user = nil
      redirect '/login'
    end
  end
end