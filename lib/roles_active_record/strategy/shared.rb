module Roles::ActiveRecord
  module Strategy
    module Shared
      def set_role role
        update_attributes(role_attribute => new_role(role))
      end
      alias_method :set_roles, :set_role

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