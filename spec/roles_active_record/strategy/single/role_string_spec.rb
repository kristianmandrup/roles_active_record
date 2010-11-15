require 'spec_helper'
use_roles_strategy :role_string

class User < ActiveRecord::Base
  include Roles::ActiveRecord 
  
  strategy :role_string, :default
  valid_roles_are :admin, :guest   
end

describe "Roles for Active Record" do
  before do
    migrate('role_string')
  end
  
  load "roles_active_record/strategy/user_setup"
  load "roles_generic/rspec/api"
end
