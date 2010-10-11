require 'migration_assist'
require 'logging_assist'

module ActiveRecord 
  module Generators
    class RolesMigrationGenerator < Rails::Generators::NamedBase 
      include Rails3::Migration::Assist
      
      desc "Generates user role migrations" 

      # name is the user model to generate roles for      

      class_option :strategy, :type => :string, :aliases => "-s", :default => 'inline_role', 
                   :desc => "Role strategy to use (admin_flag, role_string, one_role, many_roles, roles_mask)"

      class_option :reverse, :type => :boolean, :alias => "-r", :default => false, :desc => "Create a remove migration for reversing a strategy"

      def self.source_root
        @source_root ||= File.expand_path("../templates", __FILE__)
      end

      def valid_strategy?
        if !strategies.include?(strategy.to_sym)
          logger.info "Unknown role strategy #{strategy}"
          raise ArgumentError, "Unknown role strategy #{strategy}"
        end
      end

      def run_migration    
        migration_name = "add_#{strategy}_strategy"
        target_migration_name = reverse? ? reverse_migration_name(migration_name) : migration_name
        migration_template "#{migration_name}.erb", "db/migrations/#{target_migration_name}" 
        generated_migration = latest_migration_file(migration_dir, target_migration_name)
        reverse_migration!(generated_migration) if generated_migration && reverse?
      end   
      
      protected                  

      include Rails3::Assist::BasicLogger

      def strategies
        [:admin_flag, :role_string, :one_role, :many_roles, :roles_mask]          
      end
       
      def reverse?
        options[:reverse]
      end
        
      def table_name
        name.tableize
      end
      
      def strategy
        options[:strategy]
      end
    end
  end
end