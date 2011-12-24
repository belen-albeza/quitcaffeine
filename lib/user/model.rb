require 'user_settings/model'
require 'dm-aggregates'

require 'date'

class User
  include DataMapper::Resource
  
  property :id, Serial
  property :username, String, :unique_index => true
  property :created_at, DateTime
  
  has n, :shots, :constraint => :destroy
  has 1, :user_settings, :constraint => :destroy
  
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
     :caffeine_for_today => self.caffeine_for_day(Date.today)}
  end
  
  def full_stats(cache=nil)
    stats = stats_summary
    unless self.source_to_track.nil?
      stats[:units_chart] = self.units_of_source_for_week(Date.today,
                              self.source_to_track, cache)
    end
    return stats
  end
  
  def shots_for_day(date)
    self.shots.all(:created_at.gte => date,
                   :created_at.lt => date + 1)
  end
  
  def caffeine_for_day(date)
    shots_for_day(date).sum(:mg) || 0
  end
  
  def units_of_source_for_day(date, source, cache=nil)
    cache_key = "user:#{self.id}:source:#{source.nil? ? 'all' : source.slug}:date:#{date}"
    if date < Date.today() and !cache.nil?
      result = cache.get(cache_key) 
    else
      result = shots_for_day(date).count(:source => source)
    end
    
    if !result.nil? and !cache.nil?
      cache.set(cache_key, result)
    end
    
    return result
  end
  
  def units_of_source_for_week(date, source, cache=nil)
    units = []
    t = Date.today
    week = [t-6, t-5, t-4, t-3, t-2, t-1, t]
    week.each do |day|
      units.push(:day => day.strftime('%a'),
                 :units => units_of_source_for_day(day, source, cache))
    end
    
    return units
  end
  
  def cancel_account!
    self.destroy
  end
  
  # =================
  # = Class methods =
  # =================
  def User.get_or_create(username, can_register=true)
    # get user or create a brand new one
    user = User.first(:username => username)
    if can_register and user.nil?
      user = User.create(:username => username)
      if user.user_settings.nil?      
        user.user_settings = UserSettings.new
        user.save()
      end
    end
    return user
  end
end