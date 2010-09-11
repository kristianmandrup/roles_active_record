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


  it "should generate migration 'add_role_to_user' and 'create_roles' for role strategy 'one_role'" do    
    with_generator do |g|
      remove_migrations :add_role_to_users, :create_roles
            
      g.run_generator [:user, %w{--strategy one_role}].args

      g.should generate_migration :add_role_to_users do |content|
        content.should have_migration :add_role_to_users do |klass|
          klass.should have_up do |up|
            up.should have_change_table :users do |tbl_content|
              tbl_content.should have_add_column :role_id, :integer
            end
          end

          klass.should have_down do |down|
            down.should have_change_table :users do |tbl_content|
              tbl_content.should have_remove_column :role_id
            end
          end
        end
      end      

      g.should generate_migration :create_roles do |content|
        content.should have_migration :create_roles do |klass|
          klass.should have_up do |up|
            up.should have_create_table :roles do |tbl_content|
              tbl_content.should have_add_column :name, :string
              tbl_content.should have_timestamps             
            end
          end

          klass.should have_down do |down|
            down.should have_drop_table :roles
          end
        end
      end      
    end # with
  end
end