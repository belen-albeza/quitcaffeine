require 'sinatra'
require 'user/twitter'
require 'user/model'

before do
  @twitter = Social::Twitter.new(settings.twitter_config, session)
  tw_screen_name = session[:tw_screen_name]

  unless tw_screen_name.nil?
    @user = User.get_or_create(tw_screen_name, can_register?)
    if @user.nil?
      session.clear
      flash.now[:notice] = 'Sorry, new registrations are closed'
    else
      session[:user_id] = @user.id
    end
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
  
  def login_url
    '/twitter/connect'
  end
  
  def cancel_account_url
    '/profile/delete'
  end
  
  def can_register?
    get_user_count() < settings.max_users
  end
  
  def get_user_count
    count = settings.cache.get('user:count')
    if count.nil?
      count = User.all.count()
      settings.cache.set('user:count', count, settings.ttl_5mins)
    end
    return count
  end
end