def default_user_setup
  @guest_user = User.create(:name => 'Guest user')  
  @guest_user.add_roles :guest
  # @guest_user.roles = :guest
  @guest_user.save     
  
  puts "Guest roles: #{@guest_user.roles_list}"
  
  @normal_user = User.create(:name => 'Normal user')
  @normal_user.roles = :guest, :user
  @normal_user.save  
  
  puts "Normal roles: #{@normal_user.roles_list}, #{@normal_user.inspect}"
  
  @admin_user = User.create(:name => 'Admin user')
  @admin_user.roles = :admin            
  @admin_user.save
  
  puts "Admin roles: #{@admin_user.roles_list}, #{@admin_user.inspect}"  
end
