class UserSettings
  include DataMapper::Resource
  
  property :enable_tweets, Boolean, :default => true
  property :enable_public_profile, Boolean, :default => true
  
  belongs_to :user, :key => true
  belongs_to :source_to_track, :model => 'Source', :required => false
  
  def update_with_form(form)
    # parse form
    form = UserSettings.get_form_fields(form)
    # update fields
    self.enable_tweets = form[:enable_tweets]
    self.enable_public_profile = form[:enable_public_profile]
    self.source_to_track = form[:source_to_track]
    # save in DB
    self.save()
  end
  
  protected
  
  def UserSettings.get_form_fields(form)
    res = {}
    
    res[:enable_tweets] = !form[:enable_tweets].nil?
    res[:enable_public_profile] = !form[:enable_public_profile].nil?
    res[:source_to_track] = Source.first(:slug => form[:source_to_track])
    
    return res
  end
end
