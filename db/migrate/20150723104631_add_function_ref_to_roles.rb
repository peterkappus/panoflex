class AddFunctionRefToRoles < ActiveRecord::Migration
  def change
    add_reference :roles, :function, index: true, foreign_key: true
  end
end
