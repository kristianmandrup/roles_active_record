require 'spec_helper'
use_roles_strategy :roles_mask

class User < ActiveRecord::Base    
  include Roles::ActiveRecord
  
  strategy :roles_mask, :default
  valid_roles_are :admin, :guest   
end

describe "Roles for Active Record" do
  before do
    migrate('roles_mask')
  end

  load "roles_active_record/strategy/user_setup"
  load "roles_generic/rspec/api"
end
