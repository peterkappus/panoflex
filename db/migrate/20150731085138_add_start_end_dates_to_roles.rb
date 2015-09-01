class AddStartEndDatesToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :start_date, :date
    add_column :roles, :end_date, :date
  end
end
