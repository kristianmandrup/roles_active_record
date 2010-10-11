module Roles::Base
  def valid_roles_are(*role_list)
    strategy_class.valid_roles = role_list.to_symbols
  end
end

module Roles::ActiveRecord  
  def self.included(base) 
    base.extend Roles::Base
    base.extend ClassMethods
    base.orm_name = :active_record
  end

  module ClassMethods      
    def strategy name, options=nil
      set_role_strategy name, options
    end    
  end
end
