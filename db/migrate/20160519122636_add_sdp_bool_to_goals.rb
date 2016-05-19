class AddSdpBoolToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :sdp, :boolean
  end
end
