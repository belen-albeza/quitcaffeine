require 'sinatra'
require 'data_mapper'

# connect to the DB
DataMapper.setup(:default, ENV['DATABASE_URL'] || 
                           "sqlite3://#{Dir.pwd}/development.db")


require 'user'
require 'user_settings'
require 'source'
require 'shot'

# create DB
DataMapper.finalize
DataMapper.auto_upgrade!

def reset_db
  DataMapper.auto_migrate!
  Source.load_fixtures()
end

