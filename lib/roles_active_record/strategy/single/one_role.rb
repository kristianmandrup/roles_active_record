require 'roles_active_record/strategy/single'

class Role < ActiveRecord::Base
  scope :named, lambda{|role_names| where(:name.in => role_names.flatten)}
  has_many :users
end

module RoleStrategy::ActiveRecord
  module OneRole
    def self.default_role_attribute
      :one_role
    end

    def self.included base
      base.extend Roles::Generic::Role::ClassMethods
      base.extend ClassMethods
      base.belongs_to :one_role, :foreign_key => :role_id, :class_name => 'Role'
    end

    module ClassMethods
      def in_role(role_name)
        in_any_role(role_name)
      end

      def in_any_role(*role_names)
        joins(:one_role) & Role.named(role_names)
      end
    end

    module Implementation
      include Roles::ActiveRecord::Strategy::Single

      # def set_role role
      #   vr = new_role(role)
      #   vr.users << self
      # end

      # assign multiple roles
      def roles=(*role_names)
        role_names = extract_roles(role_names)
        return nil if role_names.empty?
        valid_roles = select_valid_roles role_names
        vrole = extract_role valid_roles.first
        set_role(vrole)
      end

      def select_valid_roles *roles
        roles = roles.flat_uniq.select{|role| valid_role? role }
        valid_roles = has_role_class? ? role_class.find_roles(roles).to_a : roles
      end

      protected

      def new_role role
        role_class.find_role(extract_role role)
      end

      def new_roles *roles
        new_role roles.flatten.first
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
