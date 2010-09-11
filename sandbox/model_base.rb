require 'require_all'
require 'active_support/inflector'
require_all File.dirname(__FILE__) + '/strategies'

 

module RoleModels::ActiveRecord
  include RoleModels::Base
  orm_name :active_record
end

 
module ActiveRecord
  class Base
    include RoleModels::ActiveRecord
  end
end


class User
  include RoleModels::Generic
  
  attr_accessor :roles_mask
  role_strategy :roles_mask
end

class User
  include RoleModels::Generic::RolesMask
  attr_accessor :roles_mask
end

class User < ActiveRecord::Base
  role_strategy :roles_mask
end

class User
  include MongoMapper::Document
  
  role_strategy :roles_mask
end

class User
  include Mongoid::Document
  
  role_strategy :roles_mask
end
