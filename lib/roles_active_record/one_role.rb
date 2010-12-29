class Role < ActiveRecord::Base
  scope :named, lambda{|role_names| where(:name.in => role_names.flatten)}
  has_many :users
  validates :name, :uniqueness => true  
  
  extend RoleClass::ClassMethods
end
