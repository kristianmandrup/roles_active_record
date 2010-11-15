module Roles::ActiveRecord
  module Strategy
    module Shared
      def set_role role
        self.send("#{role_attribute}=", new_role(role))
      end
      alias_method :set_roles, :set_role

      def get_role
        r = self.send(role_attribute)
        respond_to?(:present_role) ? present_role(r) : r
      end

      def get_roles
        r = self.send(role_attribute)
        respond_to?(:present_roles) ? present_roles(r) : r
      end

      def roles_diff *roles
        self.roles - roles.flat_uniq
      end

      def select_valid_roles *roles
        puts "select_valid_roles!"
        roles.flat_uniq.select{|role| valid_role? role }
        puts "select_valid_roles: #{roles}"
        has_role_class? ? role_class.find_roles(roles).to_a : roles
      end           
    end
  end
end