require 'sugar-high/module'

module Roles
  modules :active_record do
    nested_modules :user, :role
  end
  modules :base, :strategy
end   

module RoleStrategy
  modules :active_record
end