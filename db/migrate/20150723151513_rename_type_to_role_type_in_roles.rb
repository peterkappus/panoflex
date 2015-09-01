class RenameTypeToRoleTypeInRoles < ActiveRecord::Migration
  def change
    rename_column :roles, :type, :role_type
  end
end
