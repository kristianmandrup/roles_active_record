require 'rails3_artifactor'
require 'logging_assist'

module ActiveRecord 
  module Generators
    class RolesGenerator < Rails::Generators::NamedBase      
      desc "Add role strategy to a model" 

      # argument name
      
      class_option :strategy, :type => :string, :aliases => "-s", :default => 'role_string', 
                   :desc => "Role strategy to use (admin_flag, role_string, roles_string, role_strings, one_role, many_roles, roles_mask)"

      class_option :roles,            :type => :array,  :aliases => "-r", :default => [], :desc => "Valid roles"
      class_option :role_class,       :type => :string, :aliases => "-rc", :default => 'Role', :desc => "Role class"
      class_option :user_class,       :type => :string, :aliases => "-uc", :default => 'User', :desc => "User class"
      class_option :user_role_class,  :type => :string, :aliases => "-urc", :default => 'UserRole', :desc => "User Role join class"
      
      class_option :default_roles,    :type => :boolean,  :default => true, :desc => "Use default roles :admin and :base"
      class_option :logfile,          :type => :string,   :default => nil,   :desc => "Logfile location"

      source_root File.dirname(__FILE__) + '/templates'

      def apply_role_strategy
        logger.add_logfile :logfile => logfile if logfile
        logger.debug "apply_role_strategy for : #{strategy} in model #{name}"
        begin
          insert_into_model name do
            insertion_text
          end
        rescue
          logger.debug "Model #{name} not found"
          say "Model #{name} not found"
        end
      end 

      def copy_role_models
        logger.debug 'copy_role_models'
        case strategy.to_sym  
        when :one_role
          copy_one_role_model
        when :many_roles
          copy_many_roles_models
        end
      end
            
      protected                  

      extend Rails3::Assist::UseMacro
      use_orm :active_record
      include Rails3::Assist::BasicLogger

      def copy_one_role_model
        logger.debug "copy_one_role_model: #{role_class.underscore}"

        template 'one_role/role.rb', "app/models/#{role_class.underscore}.rb"
      end

      def copy_many_roles_models        
        logger.debug "copy_many_roles_models: #{role_class.underscore} and #{user_role_class.underscore}"

        template 'many_roles/role.rb', "app/models/#{role_class.underscore}.rb"        
        template 'many_roles/user_role.rb', "app/models/#{user_role_class.underscore}.rb"
      end

      def user_class
        options[:user_class].classify || 'User'
      end

      def role_class
        options[:role_class].classify || 'Role'
      end

      def user_role_class
        options[:user_role_class].classify || 'UserRole'
      end

      def logfile
        options[:logfile]
      end

      def user_class
        name || 'User'
      end

      def orm
        :active_record
      end
  
      def default_roles
        options[:default_roles] ? [:admin, :guest] : []        
      end
  
      def roles_to_add
        @roles_to_add ||= default_roles.concat(options[:roles]).to_symbols.uniq
      end
  
      def roles        
        roles_to_add.map{|r| ":#{r}" }
      end

      def has_valid_roles_statement? 
        !(read_model(user_class) =~ /valid_roles_are/).nil?
      end

      def valid_roles_statement
        return '' if has_valid_roles_statement?
        roles ? "valid_roles_are #{roles.join(', ')}" : ''
      end
  
      def role_strategy_statement 
        "strategy :#{strategy} #{strategy_options}"
      end

      def strategy_options
        if role_class != 'Role' || user_role_class != 'UserRole' && role_ref_strategy?
          return ", :role_class => :#{options[:role_class] || 'role'}, :user_role_class => :#{options[:user_role_class] || 'user_role'}"
        end
        ''        
      end
    
      def insertion_text
        %Q{include Roles::#{orm.to_s.camelize}
  #{role_strategy_statement}
  #{valid_roles_statement}}
      end
  
      def strategy
        options[:strategy]                
      end
    end
  end
end