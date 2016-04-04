class AddHeadcountToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :headcount, :integer
  end
end
