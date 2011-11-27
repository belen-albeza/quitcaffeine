require 'user/model'
require 'user/helpers'
require 'source/model'

class Shot
  include DataMapper::Resource
  
  property :id, Serial
  property :created_at, DateTime
  property :mg, Integer, :required => true # to avoid a JOIN when counting mg
  
  belongs_to :source
  belongs_to :user
  
  def shared_message(url)
    "I've just had #{self.source.description} #{url}"
  end
  
  # =================
  # = class methods =
  # =================
  
  def Shot.create_for_user(user_id, source_slug)
    user = User.get(user_id)
    source = Source.first(:slug => source_slug)
    if user and source
      Shot.create(:user => user, :source => source, :mg => source.mg)
    else 
      nil
    end
  end
  
end