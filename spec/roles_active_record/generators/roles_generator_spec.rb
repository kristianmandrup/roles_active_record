require 'generator_spec_helper'
require_generator :active_record => :roles

# root_dir = Rails3::Assist::Directory.rails_root
root_dir = File.join(Rails.application.config.root_dir, 'rails')

describe 'role strategy generator: admin_flag' do
  describe 'ORM: active_record' do  
    use_orm :active_record

    before do              
      setup_generator 'datamapper_roles_generator' do
        tests ActiveRecord::Generators::RolesGenerator
      end    
    end
    
    before :each do              
      remove_model :user    
    end

    after :each do
      # remove_model :user
    end

    it "should configure 'admin_flag' strategy without default roles" do            
      create_model :user do
        '# content'
      end
      with_generator do |g|   
        arguments = "User --strategy admin_flag --roles special --no-default-roles"
        puts "arguments: #{arguments}"
        g.run_generator arguments.args
        root_dir.should have_model :user do |clazz|
          clazz.should include_module 'Roles::ActiveRecord'
          clazz.should have_call :valid_roles_are, :args => ':special'
          clazz.should have_call :strategy, :args => ":admin_flag"        
        end
      end
    end
        
    it "should configure 'admin_flag' strategy" do            
      create_model :user do
        '# content'
      end
      with_generator do |g|   
        arguments = "User --strategy admin_flag --roles admin user"
        puts "arguments: #{arguments}"
        g.run_generator arguments.args
        root_dir.should have_model :user do |clazz|
          clazz.should include_module 'Roles::ActiveRecord'
          clazz.should have_call :valid_roles_are, :args => ':admin, :guest, :user'
          clazz.should have_call :strategy, :args => ":admin_flag"        
        end
      end
    end
    
    it "should configure 'one_role' strategy" do            
      create_model :user do
        '# content'
      end
      with_generator do |g|   
        arguments = "User --strategy one_role --roles admin user"
        puts "arguments: #{arguments}"
        g.run_generator arguments.args
        root_dir.should have_model :user do |clazz|
          clazz.should include_module 'Roles::ActiveRecord'
          clazz.should have_call :valid_roles_are, :args => ':admin, :guest, :user'
          clazz.should have_call :role_class, :args => ":role"        
          clazz.should have_call :strategy, :args => ":one_role"        
        end
      end
    end    
  end
end

