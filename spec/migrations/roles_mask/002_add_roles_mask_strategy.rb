class AddRolesMaskStrategy < ActiveRecord::Migration
  def self.up           
    change_table :users do |t|
      t.integer :roles_mask, :default => 0
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :roles_mask
    end
  end
end
