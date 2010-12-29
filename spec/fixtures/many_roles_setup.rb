class User < ActiveRecord::Base    
  include Roles::ActiveRecord
  
  strategy :many_roles
  valid_roles_are :admin, :guest, :user
end
