class Source
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :unique_index => true
  property :description, String
  property :slug, String, :unique_index => true
  property :mg, Integer, :default => 0
  
  has n, :shots
  # belongs_to :user_settings, :required => false
  
  def Source.load_fixtures
    Source.create(:slug => 'coke',
                  :name => 'coke',
                  :description => '1 coke',
                  :mg => 45)
    Source.create(:slug => 'coffee',
                  :name => 'coffee',
                  :description => '1 coffee',
                  :mg => 100)
    Source.create(:slug => 'coffee2x',
                  :name => 'coffee extra shot',
                  :description => '1 double coffe',
                  :mg => 200)
    Source.create(:slug => 'tea',
                  :name => 'tea',
                  :description => '1 cup of tea',
                  :mg => 50)
    Source.create(:slug => 'redbull',
                  :name => 'Red Bull',
                  :description => '1 Red Bull',
                  :mg => 80)
    Source.create(:slug => 'monster',
                  :name => 'Monster Energy',
                  :description => '1 Monster Energy',
                  :mg => 160)
  end
end