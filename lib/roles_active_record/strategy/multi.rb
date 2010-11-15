require 'roles_active_record/strategy/shared'

module Roles::ActiveRecord
  module Strategy
    module Multi     
      # assign multiple roles
      def roles=(*roles)
        roles = get_roles(roles)
        return nil if roles.empty?
        set_roles(select_valid_roles roles)
      end      
      
      def add_roles *roles
        new_roles = select_valid_roles(roles)
        if !new_roles.empty?
          self.roles = self.roles + new_roles
        end
      end      
      
      # should remove the current single role (set = nil) 
      # only if it is contained in the list of roles to be removed
      def remove_roles *roles
        roles = roles.flatten.compact
        return nil if roles_diff(roles).empty?
        roles_to_remove = select_valid_roles(roles)
        self.roles = self.roles - roles_to_remove
        true
      end

      # query assigned roles
      def roles
        get_roles.map do |role|
          role.respond_to?(:sym) ? role.to_sym : role
        end
      end

      def roles_list
        my_roles = [roles].flat_uniq
        return [] if my_roles.empty?
        has_role_class? ? my_roles.map{|r| r.name.to_sym } : my_roles          
      end
      
      protected
      
      def set_roles *roles                      
        self.send("#{role_attribute}=", new_roles(roles))
      end

      def get_roles
        self.send(role_attribute)
      end      
    end
  end
end