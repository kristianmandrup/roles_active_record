require 'spec_helper'
use_roles_strategy :many_roles

class User < ActiveRecord::Base    
  include Roles::ActiveRecord
  
  strategy :many_roles, :default
  valid_roles_are :admin, :guest, :user   
end

def api_migrate
  migrate('many_roles')
end

def api_fixture
  load 'fixtures/many_roles_setup.rb'
end

def api_name
  :many_roles
end

load 'roles_active_record/strategy/api_examples.rb'




