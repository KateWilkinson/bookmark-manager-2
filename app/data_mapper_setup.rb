require 'data_mapper'

env = ENV['RACK_ENV'] || 'development'

puts env

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/bookmark_manager_#{env}")

require './app/models/link'
require './app/models/tag'
require './app/models/user'

DataMapper.finalize

DataMapper.auto_upgrade!
