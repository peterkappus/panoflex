class AddStatusToScore < ActiveRecord::Migration
  def change
    add_column :scores, :status, :integer, default: 0
  end
end
