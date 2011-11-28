require 'user_settings/model'
require 'dm-aggregates'

class User
  include DataMapper::Resource
  
  property :id, Serial
  property :username, String, :unique_index => true
  property :created_at, DateTime
  
  has n, :shots
  has 1, :user_settings
  
  def source_to_track
     self.user_settings.source_to_track
  end
  
  def latest_shots
    self.shots.all(:order => [:created_at.desc])[0..7]
  end
  
  def last_shot(source=nil)
    source = source || self.user_settings.source_to_track
    query = {:order => [:created_at.desc]}
    query[:source] = source unless source.nil?
    self.shots.first(query)
  end
  
  def stats_summary
    source_name =  self.source_to_track ? self.source_to_track.name : nil
    {:source_to_track => source_name,
     :last_shot => self.last_shot,
     :caffeine_for_today => self.caffeine_for_day(Date.today),
     :units_for_today => self.units_of_source_for_day(Date.today,
                         self.source_to_track)}
  end
  
  def full_stats
    stats_summary
  end
  
  def shots_for_day(date)
    self.shots.all(:created_at.gte => date,
                   :created_at.lt => date + 1)
  end
  
  def caffeine_for_day(date)
    shots_for_day(date).sum(:mg) || 0
  end
  
  def units_of_source_for_day(date, source)
    shots_for_day(date).count(:source => source)
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