class Role < ActiveRecord::Base
  scope :named, lambda{|role_names| where(:name.in => role_names.flatten)}
  belongs_to :user
end

module RoleStrategy::ActiveRecord
  module OneRole
    def self.default_role_attribute
      :one_role
    end

    def self.included base
      base.extend Roles::Generic::Role::ClassMethods
      base.extend ClassMethods
      base.has_one :one_role, :foreign_key => :role_id, :class_name => 'Role'
    end

    module ClassMethods
      def in_role(role_name)
        in_roles(role_name)
      end

      def in_roles(*role_names)
        joins(:one_role) & Role.named(role_names)
      end
    end

    module Implementation
      include Roles::Generic::User::Implementation::Single

      # assign multiple roles
      def roles=(*role_names)
        role_names = extract_roles(role_names)
        return nil if role_names.empty?
        puts "Role names: #{role_names}"
        valid_roles = select_valid_roles role_names
        puts "Valid roles: #{valid_roles}"
        set_roles(valid_roles)
      end

      def select_valid_roles *roles
        puts "select_valid_roles!: #{roles.flat_uniq}"
        roles = roles.flat_uniq.select{|role| valid_role? role }
        puts "select_valid_roles: #{roles}"
        valid_roles = has_role_class? ? role_class.find_roles(roles).to_a : roles
        puts "Valid roles: #{valid_roles}"
        puts "Role all: #{Role.all}"
        valid_roles
      end

      protected

      def new_role role
        puts "New role: #{role}"
        role_class.find_role(role)
      end

      def new_roles *roles
        puts "New roles: #{roles}"
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
