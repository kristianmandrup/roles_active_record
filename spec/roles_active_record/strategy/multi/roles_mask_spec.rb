require 'spec_helper'

class User < ActiveRecord::Base
  include Roles::ActiveRecord
  
  strategy :roles_mask, :default
  valid_roles_are :admin, :guest, :user
end

def api_migrate
  migrate('roles_mask')
end

def api_name
  :roles_mask
end

load 'roles_active_record/strategy/api_examples.rb'




