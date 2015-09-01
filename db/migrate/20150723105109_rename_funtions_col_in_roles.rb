class RenameFuntionsColInRoles < ActiveRecord::Migration
  def change
    change_table :roles do |t|
      t.rename :function, :function_name
    end
  end
end
