require 'roles_active_record/strategy/multi'

module RoleStrategy::ActiveRecord
  module RolesMask
    def self.default_role_attribute
      :roles_mask
    end

    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods
      def role_attribute
        strategy_class.roles_attribute_name.to_sym
      end 

      def in_role(role)     
        mask = calc_index(role.to_s)
        all.select do |user| 
          v = user.send(role_attribute) || 0
          value = (v & mask)
          value && value > 0
        end
      end    

      def in_any_role(*roles)
        all.select do |user| 
          roles.flatten.any? do |role|
            mask = calc_index(role.to_s)
            v = user.send(role_attribute) || 0
            value = (v & mask)
            value && value > 0
          end
        end
      end    
  
      def calc_index(r)
        2**strategy_class.valid_roles.index(r.to_sym)
      end 
    end

    module Implementation
      include Roles::ActiveRecord::Strategy::Multi      

      class Roles < ::Set # :nodoc:
        attr_reader :model_instance

        def initialize(sender, *roles)
          super(*roles)
          @model_instance = sender
        end

        def <<(role)
          model_instance.roles = super.to_a
          self
        end
      end

      protected

      def calc_index(r)
        2**strategy_class.valid_roles.index(r)
      end

      def get_roles
        strategy_class::Roles.new(self, strategy_class.valid_roles.reject { |r| ((get_role || 0) & calc_index(r)).zero? })        
      end
      
      def new_roles *role_names
        role_names = role_names.flatten.map{ |r| r.to_sym } & strategy_class.valid_roles
        role_names.map { |r| calc_index(r) }.inject { |sum, bitvalue| sum + bitvalue }
      end

      def set_empty_roles
        self.send("#{role_attribute}=", 0)
      end
      
      def present_roles *role_names
        role_names.to_a.to_symbols
      end
    end    
    
    extend Roles::Generic::User::Configuration
    configure            
  end
end
