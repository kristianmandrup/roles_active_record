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


  it "should generate migration 'add_role_to_user' and 'create_roles' for role strategy 'one_role'" do    
    with_generator do |g|
      remove_migrations :add_role_to_users, :create_roles
            
      g.run_generator [:user, %w{--strategy one_role}].args

      # def up          
      #   create_roles
      #   add_user_role
      # end
      # 
      # def down      
      #   drop_roles
      #   remove_user_role
      # end

      g.should generate_migration :add_one_role_strategy do |content|
        content.should have_class_self do |class_self|        
          class_self.should have_method :up do |up|
            up.should have_call :create_roles
            up.should have_call :add_user_role
          end

          class_self.should have_method :down do |down|
            down.should have_call :drop_roles
            down.should have_call :remove_user_role
          end
        end
      end
    end # with
  end
end