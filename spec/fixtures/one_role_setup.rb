class User < ActiveRecord::Base
  include Roles::ActiveRecord 
  
  strategy :one_role
  valid_roles_are :admin, :guest, :user
  
  def initialize attributes = {}
    super
    # add_role default_role
    set_default_role
  end
end
