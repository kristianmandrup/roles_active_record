def default_user_setup
  @guest_user = User.create(:name => 'Guest user')  
  @guest_user.add_roles :guest      
  @guest_user.save     
  
  @normal_user = User.create(:name => 'Normal user')
  @normal_user.roles = :guest, :user
  puts "valid? #{@normal_user.valid?}"

  puts "Normal user: #{@normal_user.inspect}"
  puts "Normal user role: #{@normal_user.role}"

  @admin_user = User.create(:name => 'Admin user')
  @admin_user.roles = :admin            
  @admin_user.save
end
