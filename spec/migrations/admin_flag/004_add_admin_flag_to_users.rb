class AddAdminFlagToUsers < ActiveRecord::Migration
  def self.up           
    change_table :users do |t|
      t.boolean :admin_flag, :default => false
    end
    # add_column :users, :admin_flag, :boolean, :default => false    
  end

  def self.down
    change_table :users do |t|
      t.remove :admin_flag
    end
    # remove_column :users, :admin_flag
  end
end
