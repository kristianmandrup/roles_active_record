class User < ActiveRecord::Base    
  include Roles::ActiveRecord
  
  strategy :many_roles, :default
  role_class :role

  valid_roles_are :admin, :guest, :user
end
