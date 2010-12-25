require 'generator_spec_helper'

# require_generator :active_record => :roles
require 'generators/active_record/roles/roles_generator'

# root_dir = Rails3::Assist::Directory.rails_root
# root_dir = File.join(Rails.application.config.root_dir, 'rails')
root_dir = Rails.root

describe 'roles generator' do
  describe 'ORM: active_record' do  
    use_orm :active_record

    before do              
      setup_generator 'AR_generator' do
        tests ActiveRecord::Generators::RolesGenerator
      end    
    end
    
    before :each do              
      remove_model :user    
    end

    after :each do
      remove_model :user
    end
    
    it "should configure 'many_roles' strategy" do
      create_model :user do
        '# content'
      end
      with_generator do |g|   
        arguments = "User --strategy many_roles --roles admin user"
        puts "arguments: #{arguments}"
        g.run_generator arguments.args
        root_dir.should have_model :user do |clazz|
          clazz.should include_module 'Roles::ActiveRecord'
          clazz.should have_call :valid_roles_are, :args => ':admin, :guest, :user'
          clazz.should have_call :strategy, :args => ":many_roles"
        end
        
        root_dir.should have_model :role do |clazz|                  
          clazz.should have_call :validates, :args => ':name, :uniqueness => true'
          clazz.should have_call :has_many, :args => ':users, :through => :user_roles'
          clazz.should have_call :has_many, :args => ':user_roles'
        end

        root_dir.should have_model :user_role do |clazz|                  
          clazz.should have_call :belongs_to, :args => ':user'
          clazz.should have_call :belongs_to, :args => ':role'
        end
      end
    end    
  end
end
