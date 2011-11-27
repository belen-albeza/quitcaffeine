require 'user/model'
require 'source/model'

class Shot
  include DataMapper::Resource
  
  property :id, Serial
  property :created_at, DateTime
  
  belongs_to :source
  belongs_to :user

  def Shot.create_for_user(user_id, source_slug)
    user = User.get(user_id)
    source = Source.first(:slug => source_slug)
    if user and source
      Shot.create(:user => user, :source => source)
    else 
      nil
    end
  end
end