class ChangeMonthlyCostToIntegerInRoles < ActiveRecord::Migration
  def change
    change_column :roles, :monthly_cost, :integer
  end
end
