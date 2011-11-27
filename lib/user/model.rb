class User
  include DataMapper::Resource
  
  property :id, Serial
  property :username, String, :unique_index => true
  property :created_at, DateTime
  
  has n, :shots
  
  # =================
  # = Class methods =
  # =================
  def User.get_or_create(username)
    user = User.first(:username => username)
    user = User.create(:username => username) if user.nil?
    return user
  end
end