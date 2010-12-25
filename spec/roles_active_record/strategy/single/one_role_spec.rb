require 'spec_helper' 

#use_roles_strategy :one_role

def api_fixture
  load 'fixtures/one_role_setup.rb'
end

def api_migrate
  migrate('one_role')
end

def api_name
  :one_role
end

load 'roles_active_record/strategy/api_examples.rb'
