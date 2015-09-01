class AddStaffNumberToRole < ActiveRecord::Migration
  def change
    add_column :roles, :staff_number, :string
  end
end
