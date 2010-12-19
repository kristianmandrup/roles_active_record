module Roles::Base
  def valid_roles_are(*role_list)
    strategy_class.valid_roles = role_list.to_symbols
    if role_class_name
      role_list.each do |name|
        begin
          role_class_name.create(:name => name.to_s) # if !role_class_name.where(:name => name.to_s).first
        rescue
          puts "Role name: #{name} is a duplicate"
        end
      end
    end
  end
end

class Role < ActiveRecord::Base
  class << self
    def find_roles(*role_names) 
      where(:name.in => role_names.flatten)
    end

    def find_role role_name
      raise ArgumentError, "#find_role takes a single role name as argument, not: #{role_name.inspect}" if !role_name.kind_of_label?
      res = find_roles(role_name)
      res ? res.first : res
    end
  end
end  
