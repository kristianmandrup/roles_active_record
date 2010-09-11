class User < ActiveRecord::Base
  include Roles::ActiveRecord 
  
  strategy :one_role, :default
  role_class :role

  valid_roles_are :admin, :guest
end
