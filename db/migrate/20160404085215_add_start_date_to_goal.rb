class AddStartDateToGoal < ActiveRecord::Migration
  def change
    add_column :goals, :start_date, :date
  end
end
