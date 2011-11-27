require 'sinatra'
require 'data_mapper'

# connect to the DB
DataMapper.setup(:default, ENV['DATABASE_URL'] || 
                           "sqlite3://#{Dir.pwd}/development.db")


require 'user'

# create DB
DataMapper.finalize
DataMapper.auto_upgrade!

