class User < ActiveRecord::Base
  include Roles::ActiveRecord 
  
  strategy :one_role
  valid_roles_are :admin, :guest, :user
end
