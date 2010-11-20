require 'spec_helper'
use_roles_strategy :admin_flag

class User < ActiveRecord::Base    
  include Roles::ActiveRecord 
    
  strategy :admin_flag, :default
  valid_roles_are :admin, :guest
end

# DatabaseCleaner.start
def api_migrate
  migrate('admin_flag')
end

def api_name
  :admin_flag
end

load 'roles_active_record/strategy/api_examples.rb'

# describe "Roles for Active Record: admin_flag" do
#   # require "roles_active_record/strategy/user_setup.rb"    
#   # require "roles_active_record/strategy/api"
#   # require "roles_generic/rspec/api"  
# end
# 
