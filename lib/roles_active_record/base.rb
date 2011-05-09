module Roles::Base
  def valid_roles_are(*role_list)
    strategy_class.valid_roles = role_list.to_symbols
  end
end

module Roles::ActiveRecord
  mattr_accessor :warnings_on
    
  def self.included(base) 
    base.extend Roles::Base
    base.extend ClassMethods
    base.send :include, InstanceMethods
    base.orm_name = :active_record
  end

  module InstanceMethods
    def default_role?
      has_role?(default_role)
    end

    def default_role
      self.class.default_role
    end
  end

  module ClassMethods      
    def default_role
      self.to_s.gsub(/(.+)User$/, '\1').underscore.to_sym
    end 

    def default_role= drole
      @default_role = drole
    end 

    def valid_single_strategies
      [:admin_flag, :one_role, :role_string]
    end

    def valid_multi_strategies
      [:many_roles, :roles_mask]
    end

    def strategies_with_role_class
      [:one_role, :many_roles]
    end 

    def valid_strategies
      valid_single_strategies + valid_multi_strategies
    end
    
    def strategy name, options = {}
      strategy_name = name.to_sym
      raise ArgumentError, "Unknown role strategy #{strategy_name}" if !valid_strategies.include? strategy_name
      use_roles_strategy strategy_name
            
      set_role_class(strategy_name, options) if strategies_with_role_class.include? strategy_name

      # one_role reference
      if strategy_name == :one_role
        self.belongs_to :one_role, :foreign_key => 'role_id', :class_name => role_class_name.to_s
      end
      
      # many_roles references
      if strategy_name == :many_roles      
        urc = user_roles_class options
        instance_eval many_roles_stmt(urc)
      end
      
      set_role_strategy name, options
    end    
    
    private
     
    def many_roles_stmt urc
      %{
        has_many :many_roles, :through => :#{urc}, :source => :#{role_class_name.to_s.underscore}
        has_many :#{urc}
      }
    end

    def role_class_name options = {}
      return @role_class_name if @role_class_name  
      return options[:role_class] if options.kind_of?(Hash) && options[:role_class] 
      'Role'    
    end

    def user_roles_class options
      return options[:user_roles_class] if options.kind_of?(Hash) && options[:user_roles_class]
      'user_roles'
    end

    def set_role_class strategy_name, options = {}
      @role_class_name = !options.kind_of?(Symbol) ? get_role_class(strategy_name, options) : default_role_class(strategy_name)
    end

    def statement code_str
      code_str.gsub /Role/, @role_class_name.to_s
    end

    def default_role_class strategy_name
      require "roles_active_record/#{strategy_name}"
      # if !defined? ::Role
      #   require "roles_active_record/#{strategy_name}"
      #   puts "Using default Role classes since they have not yet been defined" # if Roles::ActiveRecord.warnings_on
      #   return ::Role 
      # end
      # if defined? ::Role      
      #   
      #   puts "Role is defined"
      #   return ::Role
      # end
      # puts "Late binding!!!"
      ::Role
    end
    
    def get_role_class strategy_name, options
      options[:role_class] ? options[:role_class].to_s.camelize.constantize : default_role_class(strategy_name)
    end
  end
end
