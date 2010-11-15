require 'spec_helper' 
use_roles_strategy :many_roles

class Role < ActiveRecord::Base
end

class User < ActiveRecord::Base
  include Roles::ActiveRecord 
      
  strategy :many_roles, :default
  valid_roles_are :admin, :guest
  role_class :role
end

migrate('many_roles')

describe "Roles for Active Record: many_roles" do
  before :each do
    load 'fixtures/many_roles_setup.rb'
  end

  require "roles_active_record/strategy/user_setup"
  # require "roles_generic/rspec/api"       
  require "roles_active_record/strategy/api"  
end

