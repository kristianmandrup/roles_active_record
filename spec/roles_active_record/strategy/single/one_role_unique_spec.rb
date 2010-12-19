require 'spec_helper' 
use_roles_strategy :one_role

def api_fixture
  load 'fixtures/one_role_setup_unique_check.rb'
end

def api_migrate
  migrate('one_role')
end

def api_name
  :one_role
end

describe "Roles for Active Record: #{api_name}" do   
  require "roles_active_record/strategy/user_setup.rb"

  before do
    api_fixture
    default_user_setup    
  end

  describe '#valid_roles' do
    context ':guest role twice in list of valid roles' do
      it 'roles table should not have duplicate role :guest' do  
        Role.all.map(&:name).select{|n| n == 'guest'}.size.should == 1
      end
    end
  end
end