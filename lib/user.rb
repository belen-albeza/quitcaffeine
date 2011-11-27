require 'user/model'
require 'user/routes'
require 'user/helpers'

class User
  include DataMapper::Resource
  
  property :id, Serial
  property :username, String  
  property :created_at, DateTime
  
  # =================
  # = Class methods =
  # =================
  def User.get_or_create(username)
    user = User.get(:username => username)
    user ||= User.create(:username => username,
                         :created_at => Time.now)
    return user
  end
  
end