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

  it "should generate migrations 'create_roles' and 'create_user_roles' for role strategy 'many_roles'" do    
    with_generator do |g|
      remove_migration :add_many_roles_strategy
      g.run_generator "User --strategy many_roles".args
  
      g.should generate_migration :add_many_roles_strategy do |content|
        content.should have_migration :add_many_roles_strategy do |klass|
          klass.should have_class_self do |class_self|
            class_self.should have_method :up do |up|
              up.should have_call :create_user_roles
              up.should have_call :create_roles
            end
            
            class_self.should have_method :create_user_roles do |method|
              method.should have_create_table :user_roles do |tbl_content|
                tbl_content.should have_add_column :role_id, :integer
                tbl_content.should have_add_column :user_id, :integer
                tbl_content.should have_timestamps
              end
            end

            class_self.should have_method :create_roles do |method|        
              method.should have_create_table :roles do |tbl_content|
                tbl_content.should have_add_column :name, :string
                tbl_content.should have_timestamps
              end
            end
            
            class_self.should have_method :down do |down|
              down.should have_call :drop_user_roles
              down.should have_call :drop_roles 
            end
            
            class_self.should have_method :drop_user_roles
            class_self.should have_method :drop_roles
          end
        end
      end
    end # with
  end
end