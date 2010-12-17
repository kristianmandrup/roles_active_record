require 'rspec/core'
# require 'autotest/rspec2'
require 'rails'
require 'active_record'
require 'arel'
require 'meta_where'
require 'yaml'
require 'logger'
require 'database_cleaner'
require 'roles_active_record'

module Rails
  def self.config_root_dir
    File.dirname(__FILE__)
  end
end

SPEC_DIR = File.dirname(__FILE__)

path = SPEC_DIR + '/db/database.yml'
dbfile = File.open(path)
dbconfig = YAML::load(dbfile)  
ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Base.logger = Logger.new(STDERR)

# Attempts at trying to make database_cleaner accept another location for database.yml
# ------------------------------------------------------------------------------------

# module ActiveRecord
#   def self.config_file_location 
#     File.dirname(__FILE__) + '/db/database.yml'
#   end
# end

# module DatabaseCleaner
#   module ActiveRecord
#     def self.config_file_location
#       "#{DatabaseCleaner.app_root}/spec/db/database.yml"
#     end
#   end
# end

DatabaseCleaner.strategy = :truncation

def api_fixture
end

# $ rake VERSION=0

def migration_folder(name)
  path = File.dirname(__FILE__) + "/migrations/#{name}"
end

ORM_NAME = 'Active Record'

def migrate(name)                
  mig_folder = migration_folder(name)
  puts "Migrating folder: #{mig_folder}"
  ActiveRecord::Migrator.migrate mig_folder
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    # DatabaseCleaner.clean 
  end

  config.before(:each) do
    DatabaseCleaner.start
    migrate('users')  
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end  
end


