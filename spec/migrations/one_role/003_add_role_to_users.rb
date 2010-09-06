class AddRoleToUsers < ActiveRecord::Migration
  def self.up           
    change_table :users do |t|
      t.integer :role_id
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :role_id
    end
  end
end
