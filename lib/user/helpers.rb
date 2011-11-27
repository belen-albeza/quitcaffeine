require 'sinatra'
require 'user/twitter'

before do
  @twitter = Social::Twitter.new(settings.twitter_config, session)
  tw_screen_name = session[:tw_screen_name]

  unless tw_screen_name.nil?
    @user = User.get_or_create(tw_screen_name)
    session[:user_id] = @user.id
  else
    @user = nil
  end  
end

helpers do
  def login_required
    redirect home_url if @user.nil?
  end
  
  def profile_url(user)    
    "/profile/#{user.username}"
  end
  
  def logout_url
    '/logout'
  end
end