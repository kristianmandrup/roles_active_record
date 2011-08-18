def default_user_setup
  @empty_user = User.create(:name => 'Empty user')
 #  @empty_user.add_role :user
  @empty_user.save

  @guest_user = User.create(:name => 'Guest user')
  @guest_user.add_roles :guest
  @guest_user.save

  @normal_user = User.create(:name => 'Normal user')
  @normal_user.roles = :guest, :user
  @normal_user.save

  @admin_user = User.create(:name => 'Admin user')
  @admin_user.roles = :admin
  @admin_user.save

  @default_user = User.create(:name => 'def User')
  @default_user.add_role :user

  @default_user.save
  # puts "Admin roles: #{@admin_user.roles_list}, #{@admin_user.inspect}, #{Role.all}"
end
