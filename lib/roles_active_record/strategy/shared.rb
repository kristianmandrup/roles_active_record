module Roles::ActiveRecord
  module Strategy
    module Shared

      def set_default_role
        add_role default_role
      end
                        
      def set_role role
        update_attributes(role_attribute => new_role(role))
      end
      alias_method :set_roles, :set_role

      def remove_all_roles!
        set_empty_role        
      end

      def has_no_roles?
        get_role.empty?
      end

      def has_any_roles?
        !has_no_roles?
      end

      def get_role
        r = self.send(role_attribute)
      end
      alias_method :get_roles, :get_role

      def select_valid_roles *roles
        roles.flat_uniq.select{|role| valid_role? role }
        has_role_class? ? role_class.find_roles(roles).to_a.flat_uniq : roles.flat_uniq
      end           
    end
  end
end