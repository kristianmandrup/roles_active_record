require 'rspec'
require 'rspec/autorun'
require 'active_record'
require 'yaml'
require 'logger'
require 'database_cleaner'
require 'roles_for_ar'
require 'generator_spec'

RSpec::Generator.configure do |config|
  config.debug = true
  config.remove_temp_dir = true
  config.default_rails_root(__FILE__) 
  config.lib = File.dirname(__FILE__) + '/../../../lib'
  config.logger = :stdout
end
  
