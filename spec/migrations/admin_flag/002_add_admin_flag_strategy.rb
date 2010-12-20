class AddAdminFlagStrategy < ActiveRecord::Migration
  def self.up           
    change_table :users do |t|
      t.boolean :admin_flag, :default => false
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :admin_flag
    end
  end
end
