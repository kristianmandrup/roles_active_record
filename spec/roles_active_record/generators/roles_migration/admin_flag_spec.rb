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
    
  # it "should generate migration 'add_admin_flag_strategy' for role strategy 'admin_flag'" do    
  #   with_generator do |g|
  #     remove_migration :add_admin_flag_strategy
  #     g.run_generator "User --strategy admin_flag".args
  # 
  #     g.should generate_migration :add_admin_flag_strategy do |content|
  #       content.should have_migration :add_admin_flag_strategy do |klass|
  #         klass.should have_up do |up|
  #           up.should have_change_table :users do |tbl_content|
  #             tbl_content.should have_add_column :admin_flag, :boolean
  #           end
  #         end
  # 
  #         klass.should have_down do |down|
  #           down.should have_change_table :users do |tbl_content|
  #             tbl_content.should have_remove_column :admin_flag
  #           end
  #         end
  #       end
  #     end      
  #   end # with
  # end
  
  it "should generate reverse migration 'remove_admin_flag_strategy' for role strategy 'admin_flag'" do    
    with_generator do |g|
      remove_migration :remove_admin_flag_strategy
      g.run_generator "User --strategy admin_flag --reverse".args
  
      g.should generate_migration :remove_admin_flag_strategy do |content|
        content.should have_migration :remove_admin_flag_strategy do |klass|
          klass.should have_down do |down|
            down.should have_change_table :users do |tbl_content|
              tbl_content.should have_add_column :admin_flag, :boolean
            end
          end
  
          klass.should have_up do |up|
            up.should have_change_table :users do |tbl_content|
              tbl_content.should have_remove_column :admin_flag
            end
          end
        end
      end      
    end # with
  end
  
end



