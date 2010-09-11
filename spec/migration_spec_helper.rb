require 'rspec'
require 'rspec/autorun'
require 'active_record'
require 'yaml'
require 'logger'
require 'database_cleaner'
require 'roles_active_record'
require 'migration-spec'
require 'generator-spec'

Rails::Migration::Assist.rails_root_dir = File.expand_path(File.dirname(__FILE__) + '/../tmp/rails')

RSpec::Generator.configure do |config|
  config.debug = true
  config.remove_temp_dir = false # true
  config.default_rails_root(__FILE__) 
  config.lib = File.dirname(__FILE__) + '/../lib'
  config.logger = :stdout
end
  
