require 'roles_active_record/strategy/single'

module RoleStrategy::ActiveRecord
  module OneRole
    def self.default_role_attribute
      :one_role
    end

    def self.included base
      base.extend Roles::Generic::Role::ClassMethods
      base.extend ClassMethods
    end

    module ClassMethods
      def in_role(role_name)
        in_any_role(role_name)
      end

      def in_any_role(*role_names)
        matching_roles = Role.named(role_names)
        User.where(:role_id => matching_roles.map(&:id))
      end
    end

    module Implementation
      include Roles::ActiveRecord::Strategy::Single

      def set_role role
        role = role.first if role.kind_of? Array
        role.users << self
      end
      alias_method :set_roles, :set_role

      def new_role role
        role_class.find_role(extract_role role)
      end

      def new_roles *roles
        new_role roles.flatten.first
      end

      def remove_roles *role_names
        roles = role_names.flat_uniq
        set_empty_role if roles_diff(roles).empty?
        true
      end 

      def present_roles *roles
        roles.map{|role| extract_role role}
      end

      def set_empty_role
        self.send("#{role_attribute}=", nil)
      end
    end

    extend Roles::Generic::User::Configuration
    configure :num => :single, :type => :role_class
  end
end
