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
      # assign roles
      def roles=(*_roles)      
        _roles = get_roles(_roles)
        return nil if _roles.none?                

        role_relation = role_class.find_role(_roles.first) 
        self.send("#{role_attribute}=", role_relation)
      end
      alias_method :role=, :roles=
      
      # query assigned roles
      def roles
        [self.send(role_attribute).name.to_sym]
      end
      alias_method :roles_list, :roles
      
    end

    extend Roles::Generic::User::Configuration
    configure :num => :single, :type => :role_class    
  end  
end
