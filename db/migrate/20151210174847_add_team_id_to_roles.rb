class AddTeamIdToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :team_id, :integer
  end
end
