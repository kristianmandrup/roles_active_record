require 'active_record'
require 'yaml'
require 'logger'
path = File.dirname(__FILE__) + '/database.yml'
dbfile = File.open(path)
dbconfig = YAML::load(dbfile)
ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Base.logger = Logger.new(STDERR)

class User < ActiveRecord::Base
end

puts User.count
