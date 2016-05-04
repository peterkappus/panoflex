class AddAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
    remove_column :users, :is_admin?
  end
end
