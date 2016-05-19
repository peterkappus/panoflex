class RemoveSdpIdsFromGoals < ActiveRecord::Migration
  def change
      remove_column :goals, :sdp_id
      remove_column :goals, :sdp_parent_id
  end
end
