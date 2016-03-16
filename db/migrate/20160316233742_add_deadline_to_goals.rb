class AddDeadlineToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :deadline, :date
  end
end
