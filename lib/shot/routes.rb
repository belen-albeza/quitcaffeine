require 'sinatra'
require 'user/helpers'

post '/shot' do
  login_required
  shot = Shot.create_for_user(session[:user_id], params[:source_slug])
  puts shot
  if shot
    redirect home_url
  else
    raise Sinatra::NotFound
  end
end
