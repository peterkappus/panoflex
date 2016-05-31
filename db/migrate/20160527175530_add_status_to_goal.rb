class AddStatusToGoal < ActiveRecord::Migration
  def up
    add_column :goals, :status, :integer, default: 0

    #assign statuses based on current "scores" (latest updates)
    Goal.all.each do |g|
      if g.score.present?
        g.status = g.score.status
      else
        g.status = Score.new(status: :not_started).status
      end
      g.save!
    end
  end

  def down
    remove_column :goals, :status
  end
end
