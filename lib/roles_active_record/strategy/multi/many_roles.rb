require 'roles_active_record/strategy/multi'

module RoleStrategy::ActiveRecord
  module ManyRoles
    def self.default_role_attribute
      :many_roles
    end

    def self.included base
      base.extend Roles::Generic::Role::ClassMethods
      base.extend ClassMethods
      base.has_many :many_roles, :through => :user_roles, :source => :role
      base.has_many :user_roles
    end

    module ClassMethods
      def in_role(role_name)
        in_any_role(role_name)
      end

      def in_any_role(*role_names)
        joins(:many_roles) & Role.named(role_names.to_strings)
      end
    end

    module Implementation
      include Roles::ActiveRecord::Strategy::Multi

      # assign multiple roles
      def roles=(*role_names)
        role_names = role_names.flat_uniq
        role_names = extract_roles(role_names)
        return nil if role_names.empty?
        valids = role_class.find_roles(role_names).to_a
        vrs = select_valid_roles role_names
        set_roles(vrs)
      end

      def new_roles *role_names
        role_class.find_roles(extract_roles role_names)
      end

      def present_roles roles_names
        roles_names.to_a.map{|role| role.name.to_s.to_sym}
      end

      def set_empty_roles
        self.send("#{role_attribute}=", [])
      end
    end

    extend Roles::Generic::User::Configuration
    configure :type => :role_class
  end
end
