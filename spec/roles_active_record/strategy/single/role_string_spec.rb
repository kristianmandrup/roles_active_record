require 'spec_helper'
use_roles_strategy :role_string

class User < ActiveRecord::Base
  include Roles::ActiveRecord 
  
  strategy :role_string, :default
  valid_roles_are :admin, :guest   
end

def api_migrate
  migrate('role_string')
end

def api_name
  :role_string
end

load 'roles_active_record/strategy/api_examples.rb'




