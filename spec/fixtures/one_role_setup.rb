class User < ActiveRecord::Base
  include Roles::ActiveRecord 
  
  strategy :one_role
  valid_roles_are :admin, :guest, :user
  
  def initialize attributes = {}
    super
#    role = default_role
    add_role default_role
  end
end
