class AddSdpFieldsToGoal < ActiveRecord::Migration
  def change
    add_column :goals, :sdp_id, :string
    add_column :goals, :sdp_parent_id, :integer
  end
end
