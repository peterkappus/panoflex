class AddScoreToGoal < ActiveRecord::Migration
  def change
    add_column :goals, :score_amount, :integer
    add_column :goals, :scored_at, :datetime
  end
end
