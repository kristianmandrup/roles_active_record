require 'migration_spec_helper'
require_generator :active_record => :roles_migration

describe 'roles_migration_generator' do
  use_orm :active_record  
  use_helper :migration
  
  before :each do              
    setup_generator 'roles_migration_generator' do
      tests ActiveRecord::Generators::RolesMigrationGenerator
    end    
  end

  after :each do
  end


  it "should generate migration 'add_role_string_strategy' for role strategy 'role_string'" do    
    
    # class AddRoleStringStrategy < ActiveRecord::Migration
    #   def self.up           
    #     change_table :users do |t|
    #       t.string :role, :default => 'guest'
    #     end
    #   end
    # 
    #   def self.down
    #     change_table :users do |t|
    #       t.remove :role
    #     end
    #   end
    # end
    
    
    with_generator do |g|
      remove_migration :add_role_string_strategy
      g.run_generator [:user, %w{--strategy role_string}].args

      g.should generate_migration :add_role_string_strategy do |content|
        content.should have_up do |up|
          up.should have_change_table :users do |tbl_content|
            tbl_content.should have_add_column :role, :string
          end
        end

        content.should have_down do |down|
          down.should have_change_table :users do |tbl_content|
            tbl_content.should have_remove_column :role
          end
        end
      end
    end # with
  end
end 
