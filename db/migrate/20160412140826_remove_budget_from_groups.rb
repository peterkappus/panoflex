class RemoveBudgetFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :budget, :string
  end
end
