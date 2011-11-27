require 'user_settings/model'

class User
  include DataMapper::Resource
  
  property :id, Serial
  property :username, String, :unique_index => true
  property :created_at, DateTime
  
  has n, :shots
  has 1, :user_settings
  
  def latest_shots
    self.shots.all(:order => [:created_at.desc])[0..10]
  end
  
  # =================
  # = Class methods =
  # =================
  def User.get_or_create(username)
    # get user or create a brand new one
    user = User.first(:username => username)
    user = User.create(:username => username) if user.nil?
    if user.user_settings.nil?      
      user.user_settings = UserSettings.new
      user.save()
    end
      
    return user
  end
end