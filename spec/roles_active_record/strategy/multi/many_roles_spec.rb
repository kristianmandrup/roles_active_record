require 'spec_helper'

class Role < ActiveRecord::Base
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




