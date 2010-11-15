require 'spec_helper' 
use_roles_strategy :one_role

migrate('users')
migrate('one_role')
      
describe "Roles for Active Record: one_role" do   
    before do
      migrate('one_role')
    end

  before :each do    
    load 'spec/fixtures/one_role_setup.rb'        
  end
  
  require "roles_active_record/strategy/user_setup.rb"        
  require "roles_active_record/strategy/api"
  # require "roles_generic/rspec/api"  
end


# use_roles_strategy :one_role
# 
# migrate('one_role')
# 
# describe "Roles for Active Record" do
#   before do
#     migrate('one_role')
#   end
# 
#   context "default setup" do
# 
#     before :each do
#       load 'fixtures/one_role_setup.rb'
# 
#       @user = User.create(:name => 'Kristian')
#       @user.role = :guest      
#       @user.save
#       
#       puts "user: #{@user.one_role.inspect}"     
#       puts "role: #{Role.first.inspect}"     
# 
#       @admin_user = User.create(:name => 'Admin user')
#       @admin_user.role = :admin            
#       @admin_user.save
#     end
