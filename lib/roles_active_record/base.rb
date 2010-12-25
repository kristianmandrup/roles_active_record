module Roles::Base
  def valid_roles_are(*role_list)
    strategy_class.valid_roles = role_list.to_symbols
  end
end

module Roles::ActiveRecord  
  def self.included(base) 
    base.extend Roles::Base
    base.extend ClassMethods
    base.orm_name = :active_record
  end

  module ClassMethods      
    MAP = {
      :admin_flag   => "attr_accessor :admin_flag",

      :many_roles   => "attr_accessor :many_roles",
      :one_role     => "belongs_to :one_role, :foreign_key => :role_id, :class_name => 'Role'",

      :embed_many_roles   => "attr_accessor :many_roles",
      :embed_one_role     => "attr_accessor :one_role",

      :roles_mask   => "attr_accessor :roles_mask",
      :role_string  => "attr_accessor :role_string",
      :role_strings => "attr_accessor :role_strings",
      :roles_string => "attr_accessor :roles_string"
    }    
    
    def strategy name, options = {}
      strategy_name = name.to_sym
      raise ArgumentError, "Unknown role strategy #{strategy_name}" if !MAP.keys.include? strategy_name
      use_roles_strategy strategy_name
            
      if !options.kind_of? Symbol
        @role_class_name = get_role_class(strategy_name, options)
      else
        @role_class_name = default_role_class(strategy_name) if strategies_with_role_class.include? strategy_name
      end

      if (options == :default || options[:config] == :default) && MAP[name]
        instance_eval statement(MAP[strategy_name])
      end       

      set_role_strategy name, options
    end    
    
    private

    def statement code_str
      code_str.gsub /Role/, @role_class_name.to_s
    end

    def default_role_class strategy_name
      if defined? ::Role
        require "roles_active_record/#{strategy_name}"
        return ::Role 
      end
      raise Error, "Default Role class not defined"
    end

    def strategies_with_role_class
      [:one_role, :embed_one_role, :many_roles,:embed_many_roles]
    end 
    
    def get_role_class strategy_name, options
      options[:role_class] ? options[:role_class].to_s.camelize.constantize : default_role_class(strategy_name)
    end
  end
end
