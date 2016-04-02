class AddBudgetToGroups < ActiveRecord::Migration
  def change
    #looks like we have to create the column, then monetize it
    add_column :groups, :budget, :integer

    #use monetize insead of add_money since we're using PG database...
    add_monetize :groups, :budget
  end
end
