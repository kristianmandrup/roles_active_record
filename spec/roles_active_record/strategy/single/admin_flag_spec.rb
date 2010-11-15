require 'spec_helper'
use_roles_strategy :admin_flag

class User < ActiveRecord::Base    
  include Roles::ActiveRecord 
    
  strategy :admin_flag, :default
  valid_roles_are :admin, :guest
end

DatabaseCleaner.start
migrate('admin_flag')

describe "Roles for Active Record: admin_flag" do
  require "roles_active_record/strategy/user_setup.rb"    
  require "roles_active_record/strategy/api"
  # require "roles_generic/rspec/api"  
end

