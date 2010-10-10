require 'spec_helper' 
use_roles_strategy :many_roles

migrate('many_roles')

describe "Roles for Active Record" do
  before do
    migrate('many_roles')
  end

  before :each do
    load 'fixtures/many_roles_setup.rb'
  end

  load "roles_active_record/strategy/user_setup"
  load "roles_generic/rspec/api"       
end

