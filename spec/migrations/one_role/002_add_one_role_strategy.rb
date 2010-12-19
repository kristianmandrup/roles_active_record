class AddOneRoleStrategy < ActiveRecord::Migration
  class << self

    def up          
      create_roles
      add_user_role      
      add_index :roles, :name, :unique => true
      # insert_roles      
    end

    def down      
      drop_roles
      remove_user_role
      
      remove_index :roles, :name
    end

    protected

    def add_user_role
      change_table :users do |t|
        t.integer :role_id
      end
    end

    def remove_user_role
      change_table :users do |t|
        t.remove :role_id
      end
    end

    def create_roles
      create_table :roles do |t|
        t.string  :name, :null => false
        t.timestamps
      end
    end

    def drop_roles
      drop_table :roles
    end

    def insert_roles
      roles_to_add.each do |role|         
        begin
          Role.create(:name => "#{role}") # if !Role.where(:name => name.to_s).first
        rescue
        end
      end
    end
  end
end
