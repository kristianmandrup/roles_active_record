describe "Roles for Active Record: #{api_name}" do   
  before do
    api_migrate    
  end

  before :each do
    api_fixture        
  end
  
  require "roles_active_record/strategy/user_setup.rb"

  before do
    default_user_setup
  end

  describe '#in_role' do
    it "should return first user matching role" do
      if User.respond_to? :in_role
        User.in_role(:guest).first.name.should == 'Guest user'
        User.in_role(:admin).first.name.should == 'Admin user'
      end
    end
  end
  
  describe '#in_any_role' do
    it "should return first user matching role" do
      if User.respond_to? :in_roles
        User.in_any_role(:guest, :user).first.name.should == 'Guest user'
        User.in_any_role(:admin, :guest).should be_empty
      end
    end
  end
  
  it "should be true that a User that includes Roles::Generic has a complete Roles::Generic interface" do
    # mutation API
    [:roles=, :role=, :add_roles, :add_role, :remove_role, :remove_roles, :exchange_roles, :exchange_role].each do |api_method|
      @admin_user.respond_to?(api_method).should be_true
    end
  
    # inspection API
    [:valid_role?, :valid_roles?, :has_roles?, :has_role?, :has?, :is?, :roles, :roles_list, :admin?].each do |api_method|
      @admin_user.respond_to?(api_method).should be_true
    end                  
  
    # class method API
    [:valid_role?, :valid_roles?, :valid_roles].each do |class_api_method|
      @admin_user.class.respond_to?(class_api_method).should be_true
    end
  end 

  describe '#default_role' do
    it "should be true that the default user role is empty when no valid role matches class name in lowercase (no :user)" do      
      @default_user.class.default_role.should == :user      
      @default_user.default_role.should == :user
      @default_user.has_role?(:user).should be_true
    end
  
    it "should be true that the User class has a valid role of :guest" do      
      @default_user.valid_role?(:user).should be_true
    end
  end

  describe '#default_role?' do
    it "should be true that the default User has a role that is the default role" do      
      @default_user.default_role?.should be_true
    end

    it "should not be that after changing the role it is still the default role" do
      @default_user.role = :admin
      @default_user.default_role?.should be_false
    end  
  end 
  
  describe '#valid_role?' do
    it "should be true that the admin user has a valid role of :guest" do      
      # @admin_user.valid_role?(:guest).should be_true
    end
  
    it "should be true that the User class has a valid role of :guest" do      
      # User.valid_role?(:guest).should be_true
    end
  end  
  
  describe '#valid_roles' do
    it "should be true that the admin user has a valid role of :guest" do      
      # @admin_user.valid_roles.should include(:guest, :admin)
    end
  
    it "should be true that the User class has a valid role of :guest" do      
      User.valid_roles.should include(:guest, :admin)
    end
  end
  
  describe '#valid_roles?' do
    it "should be true that the admin user has a valid role of :guest" do      
      @admin_user.valid_roles?(:guest, :admin).should be_true
    end
  
    it "should be true that the User class has a valid role of :guest" do      
      User.valid_roles?(:guest, :admin).should be_true
    end
  end    
  
  describe '#has_role?' do     
    it "should have admin user role to :admin and not to :user" do            
      @admin_user.has_role?(:user).should be_false
      @admin_user.has_role?(:admin).should be_true
    end
  
    it "should be true that guest user has role :guest and not :admin" do      
      puts "Guest user: #{@guest_user.roles_list}"
      @guest_user.has_role?(:guest).should be_true    
      @guest_user.has_role?(:admin).should be_false
    end
  end  
  
  describe '#has?' do    
    it "should be true that the admin_user has the :admin role" do      
      @admin_user.has?(:admin).should be_true      
    end
  
    it "should NOT be true that the admin_user has the :admin role" do      
      @guest_user.has?(:admin).should be_false
    end
  end
  
  describe '#has_roles?' do
    it "should be true that the admin_user has the roles :admin" do      
      # @admin_user.has_roles?(:admin).should be_true
    end
  
    it "should NOT be true that the user has the roles :admin" do
      @guest_user.has_roles?(:admin).should be_false
    end
  end 
           
  describe '#roles_list' do
    it "should be true that the first role of admin_user is the :admin role" do      
      @admin_user.roles_list.should include(:admin)
    end
  
    it "should be true that the first role of admin_user is the :user role" do            
      case @normal_user.class.role_strategy.multiplicity
      when :single
        #if @normal_user.class.role_strategy.name == :admin_flag
        @normal_user.roles_list.should include(:guest)
        # else
        #   @normal_user.roles_list.should include(:user)
        #end
      when :multi
        puts "Norm: #{@normal_user.roles}"
        @normal_user.roles_list.should include(:user, :guest)
      end
    end
  end 
  
  describe '#roles' do
    it "should be true that the roles of admin_user is an array with the role :admin" do      
      roles = @admin_user.roles
      if defined?(Role) && roles.kind_of?(Role)
        roles.name.to_sym.should == :admin
      elsif roles.kind_of? Array
        if @normal_user.class.role_strategy.type == :complex
          roles.first.name.to_sym.should == :admin
        end
        if @normal_user.class.role_strategy.name == :admin_flag
          roles.first.should == true          
        end
      else       
        roles.to_sym.should == :admin
      end
    end
  end 
  
  describe '#admin?' do    
    it "should be true that admin_user is in the :admin role" do      
      @admin_user.admin?.should be_true
    end
  
    it "should NOT be true that the user is in the :admin role" do      
      @guest_user.admin?.should be_false
    end
  end 
  
  describe '#is?' do          
    it "should be true that admin_user is in the :admin role" do      
      @admin_user.is?(:admin).should be_true
    end
  
    it "should NOT be true that the user is in the :admin role" do      
      @guest_user.is?(:admin).should be_false
    end
  end    
  
  describe '#roles=' do
    it "should set user role to :admin" do
      @guest_user.roles = :admin      
      @guest_user.has_role?(:admin).should be_true      
      @guest_user.roles = :guest            
    end    
    
    context 'the guest user' do
      it "should be valid after setting the roles" do
        @guest_user.should be_valid 
        lambda {@guest_user.save!}.should_not raise_error        
      end
    end    
  end 
  
  describe '#role=' do
    it "should set user role to :admin" do
      @guest_user.role = :admin      
      @guest_user.has_role?(:admin).should be_true
      @guest_user.has_role?(:guest).should be_false
      @guest_user.role = :guest
      @guest_user.has_role?(:guest).should be_true
      @guest_user.has_role?(:admin).should be_false
      
      u = User.new :name => 'kris'
      u.role = :admin
      u.has_role?(:admin).should be_true
    end    
  
    context 'the guest user' do
      it "should be valid after setting the role" do
        @guest_user.should be_valid
        lambda {@guest_user.save!}.should_not raise_error
      end
    end
  end   
  
  describe '#exchange_roles' do
    it "should exchange user role :user with role :admin" do
      @guest_user.exchange_role :guest, :with => :admin      
      @guest_user.has?(:guest).should be_false
      @guest_user.has?(:admin).should be_true
    end    
  
    it "should exchange user role :admin with roles :user and :guest" do
      case @admin_user.class.role_strategy.multiplicity
      when :single     
        lambda { @admin_user.exchange_role :admin, :with => [:user, :guest] }.should raise_error(ArgumentError)
      when :multi
        @admin_user.exchange_role :admin, :with => [:user, :guest]
        @admin_user.has_role?(:user).should be_true
        @admin_user.has_role?(:guest).should be_true
        @admin_user.has?(:admin).should be_false        
      end
    end    
    
    context 'the admin user' do
      it "should be valid after setting the role" do
        @admin_user.should be_valid
        lambda {@admin_user.save!}.should_not raise_error
      end
    end    
  end 
  
  describe '#add_role' do
    it "should add user role :admin and :guest using #add_roles" do
      @empty_user.add_role :admin
      @admin_user.has_roles?(:admin).should be_true
    end    
     
    context 'the empty user' do
      it "should be valid after setting the role" do
        @empty_user.should be_valid
      end 
      
      it "should be able to save the valid user and not raise an error" do
        lambda {@empty_user.save!}.should_not raise_error
      end
    end        
  end 
  
  describe '#add_roles' do
    it "should add user role :admin and :guest using #add_roles" do      
      if @empty_user.class.role_strategy.multiplicity == :multi
        @empty_user.remove_all_roles!
        @empty_user.has_no_roles?.should be_true
        @empty_user.has_any_roles?.should be_false
        @empty_user.add_roles :admin, :guest
        @empty_user.has_roles?(:admin, :guest).should be_true
      end
    end    
     
    context 'the empty user' do
      it "should be valid after setting the role" do
        @empty_user.should be_valid
      end 
      
      it "should be able to save the valid user and not raise an error" do
        lambda {@empty_user.save!}.should_not raise_error
      end
    end        
  end 
  
  describe '#remove_roles' do
    it "should remove user role :admin using #remove_roles" do
      @admin_user.remove_roles :admin
      @admin_user.has_role?(:admin).should_not be_true
    end    
  
    it "should remove user role :admin using #remove_role" do
      @guest_user.add_role :admin
      @guest_user.has_role?(:admin).should be_true
      @guest_user.remove_role :admin
      @guest_user.has_role?(:admin).should_not be_true
    end  
    
    context 'the guest user' do
      it "should be valid after setting the role" do
        @guest_user.should be_valid
      end 
      
      it "should be able to save the valid user and not raise an error" do
        lambda {@guest_user.save!}.should_not raise_error
      end
    end        
  end 
end
