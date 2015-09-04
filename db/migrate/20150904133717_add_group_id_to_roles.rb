class AddGroupIdToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :group_id, :integer
  end
end
