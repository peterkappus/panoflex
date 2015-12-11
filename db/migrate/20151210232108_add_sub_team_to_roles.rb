class AddSubTeamToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :sub_team, :string
  end
end
