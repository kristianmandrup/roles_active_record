require 'generators/migration_helper'
require 'generators/role_migrations'
require 'auth_assistant/model/user_config'

module AuthAssistant 
  module Generators
    class SetupGenerator < Rails::Generators::NamedBase
      desc "Sets up Devise Users and creates Role migrations" 

      class_option :devise, :type => :boolean, :aliases => "-d", :default => false,
                                     :desc => "Initialize devise."

      class_option :admin, :type => :boolean, :aliases => "-a", :default => false,
                                    :desc => "Create admin user."


      class_option :migration, :type => :boolean, :aliases => "-m", :default => true,
                                     :desc => "To generate a user role migration."
           
      hook_for :orm
            
      def self.source_root
        @source_root ||= File.expand_path("../../templates", __FILE__)
      end

      def run_migration
        clear_relations :user        
        return nil if !options[:migration]                 
        clazz = AuthAssist::RoleMigrations.clazz(name)
        mig_obj = clazz.new(self)
        mig_obj.run_migration if mig_obj.respond_to? :run_migration
        mig_obj.configure if mig_obj.respond_to? :configure
      end   
      
      protected                  
        include ::AuthAssist::MigrationHelper
        include ::AuthAssist::RoleMigrations      
    end
  end
end