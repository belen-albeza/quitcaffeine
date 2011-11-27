require 'user/model'
require 'source/model'

class Shot
  include DataMapper::Resource
  
  property :created_at, DateTime
  
  belongs_to :source, :key => true
  belongs_to :user, :key => true
  

  def Shot.create_for_user(user_id, source_id)
    user = User.get(user_id)
    source = Source.get(user_id)
    if user and source
      Shot.create(:user => user, :source => source)
    else 
      nil
    end
  end
end