require 'sinatra'
require 'user/helpers'

post '/shot' do
  login_required
  shot = Shot.create_for_user(session[:user_id], params[:source_slug])
  if shot
    if params[:tweet_this]
      url = permalink(profile_url(shot.user))
      @twitter.tweet!(shot.shared_message(url))
    end
    redirect home_url
  else
    raise Sinatra::NotFound
  end
end
