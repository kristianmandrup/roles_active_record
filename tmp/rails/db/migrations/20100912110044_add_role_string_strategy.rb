class AddRoleStringStrategy < ActiveRecord::Migration
  def self.up           
    change_table :users do |t|
      t.string :role, :default => 'guest'
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :role
    end
  end
end
