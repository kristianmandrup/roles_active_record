class Role < ActiveRecord::Base  
  scope :named, lambda{|role_names| where(:name.in => role_names.flatten)}  
  has_many :users, :through => :user_roles
  has_many :user_roles      
end  

class UserRole < ActiveRecord::Base  
  belongs_to :user
  belongs_to :role
end  

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
        in_roles(role_name)
      end

      def in_roles(*role_names)                          
        joins(:many_roles) & Role.named(role_names)
      end
    end
    
    module Implementation
      def role_attribute
        strategy_class.roles_attribute_name
      end 
      
      # assign roles
      def roles=(*_roles)  
        _roles = get_roles(_roles)
        return nil if _roles.none?

        role_relations = role_class.find_roles(_roles) 
        self.send("#{role_attribute}=", role_relations)
        save
      end

      def add_roles(*_roles)  
        _roles = get_roles(_roles)
        return nil if _roles.none?                

        role_relations = role_class.find_roles(_roles)
        puts "role_relations: #{role_relations.inspect}"
        self.send(role_attribute) << role_relations
        save
      end

      # query assigned roles
      def roles
        self.send(role_attribute)
      end

      def roles_list     
        [roles].flatten.map{|r| r.name }.compact.to_symbols
      end
    end 
    
    extend Roles::Generic::User::Configuration
    configure :type => :role_class    
  end
end

