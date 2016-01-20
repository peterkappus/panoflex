class AddTotalCostToRoles < ActiveRecord::Migration
  def change

    #looks like we have to create the column, then monetize it
    add_column :roles, :total_cost, :integer

    #use monetize insead of add_money since we're using PG database...
    add_monetize :roles, :total_cost
  end
end
