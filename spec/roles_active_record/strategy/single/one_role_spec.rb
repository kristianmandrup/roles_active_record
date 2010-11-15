require 'spec_helper' 
use_roles_strategy :one_role

class User < ActiveRecord::Base
  include Roles::ActiveRecord 
  
  strategy :one_role, :default
  role_class :role
end    
  
describe "Roles for Active Record: one_role" do   
  before :each do
    migrate('users')
    migrate('one_role')
    load 'fixtures/one_role_setup.rb'    
  end
  
  require "roles_active_record/strategy/user_setup.rb"
  require "roles_active_record/strategy/api"
  # require "roles_generic/rspec/api"  
end

