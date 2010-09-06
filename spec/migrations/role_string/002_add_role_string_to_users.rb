class AddRoleStringToUsers < ActiveRecord::Migration
  def self.up           
    change_table :users do |t|
      t.string :role_string, :default => 'guest'
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :role_string
    end
  end
end
