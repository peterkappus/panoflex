class AddEarliestStartDateAndLatestEndDateToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :earliest_start_date, :date
    add_column :goals, :latest_end_date, :date
  end
end
