module RoleStrategy::ActiveRecord
  module AdminFlag    
    def self.default_role_attribute
      :admin_flag
    end

    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods 
      def role_attribute
        strategy_class.roles_attribute_name.to_sym
      end
           
      def in_role(role_name) 
        case role_name.downcase.to_sym
        when :admin
          where(role_attribute => true)
        else
          where(role_attribute => false)
        end          
      end
    end

    module Implementation
      def role_attribute
        strategy_class.roles_attribute_name
      end
          
      # assign roles
      def roles=(*new_roles)                                 
        first_role = new_roles.flatten.first
        if valid_role?(first_role)
          self.send("#{role_attribute}=", new_roles.flatten.first.admin?) 
        else
          raise ArgumentError, "The role #{first_role} is not a valid role"
        end
      end

      # query assigned roles
      def roles
        role = self.send(role_attribute) ? strategy_class.admin_role_key : strategy_class.default_role_key
        [role]
      end
      alias_method :roles_list, :roles

      # query assigned roles
      def add_roles *_roles
        new_roles = _roles.flatten.map{|r| r.to_s if valid_role?(r)}.compact
        if new_roles && new_roles.not.empty?
          new_role = new_roles.compact.uniq.first
          self.roles = new_role
        end
      end

      # query assigned roles
      def add_role _role
        raise ArgumentError, '#add_role takes a single role String or Symbol as the argument' if !_role || _role.kind_of?(Array)
        add_roles _role
      end      

      # query assigned roles
      def remove_roles *_roles
        # finds only valid roles
        self.roles = self.roles - _roles
      end

      # query assigned roles
      def remove_role _role
        raise ArgumentError, "remove_role can only remove a single role" if role.kind_of? Array        
        remove_roles _role
      end      

      # query assigned roles
      def exchange_roles *_roles
        options = last_option _roles
        raise ArgumentError, "Must take an options hash as last argument with a :with option signifying which role(s) to replace with" if !options || !options.kind_of?(Hash)        
        remove_roles(_roles.to_symbols)
        options[:with] = options[:with].flatten if options[:with].kind_of? Array
        
        add_roles options[:with]
      end
      alias_method :exchange_role, :exchange_roles

      def admin?
        roles_list.include? :admin
      end

    end # Implementation
    
    extend Roles::Generic::User::Configuration
    configure :num => :single
  end   
end
