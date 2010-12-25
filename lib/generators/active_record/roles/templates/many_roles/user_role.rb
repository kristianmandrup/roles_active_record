class <%= user_role_class %> < ActiveRecord::Base
  belongs_to :<%= user_class.underscore %>
  belongs_to :<%= role_class.underscore %>
end
