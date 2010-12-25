require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require_generator :setup

describe 'setup_generator' do
  include RSpec::Rails::Orm::ActiveRecord
  include RSpec::Rails::Migration
  
  before :each do              
    setup_generator 'setup_generator' do
      tests MigrationGenerator
    end    
  end

  after :each do
  end
    
  it "should generate role migrations" do    
    with_generator do |g|
      name = 'auth_assistant::setup'
      remove_migration 'create_users'
      g.run_generator [name]
      g.should generate_migration name do |content|
        content.should have_migration name do |klass|
          klass.should have_up do |up|
            up.should have_create_table :users do |user_tbl|
              user_tbl.should have_columns :name => :string, :age => :string
            end
          end

          klass.should have_down do |up|
            up.should have_drop_table :users
          end
        end
      end
    end
  end
end



