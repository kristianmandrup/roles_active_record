require File.expand_path(File.dirname(__FILE__) + '/../migration_spec_helper')
require_generator :active_record => :roles_migration

describe 'roles_migration_generator' do
  use_orm :active_record  
  helpers :migration
  
  before :each do              
    setup_generator 'roles_migration_generator' do
      tests ActiveRecord::Generators::RolesMigrationGenerator
    end    
  end

  after :each do
  end


  it "should generate migration 'add_inline_role_to_user' for role strategy 'role_string'" do    
    with_generator do |g|
      remove_migration :add_inline_role_to_users
      g.run_generator [:user, %w{--strategy role_string}].args

      g.should generate_migration :add_inline_role_to_users do |content|
        content.should have_migration :add_inline_role_to_users do |klass|
          klass.should have_up do |up|
            up.should have_change_table :users do |tbl_content|
              tbl_content.should have_add_column :role, :string
            end
          end

          klass.should have_down do |down|
            down.should have_change_table :users do |tbl_content|
              tbl_content.should have_remove_column :role
            end
          end
        end
      end      
    end # with
  end
end 
