require 'spec_helper' 
use_roles_strategy :one_role

migrate('one_role')

describe "Roles for Active Record" do
  before do
    migrate('one_role')
  end


  before :each do
    load 'fixtures/one_role_setup.rb'
  end
    
  load "roles_active_record/strategy/user_setup"
  load "roles_generic/rspec/api"       
end