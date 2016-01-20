class Goal < ActiveRecord::Base
  belongs_to :team
  belongs_to :group
  belongs_to :parent_goal, :class_name=>'Goal', :foreign_key=>'parent_goal_id'

  def group_name
    group.nil? ? "" : group.name
  end

  def team_name
    team.nil? ? "" : team.name
  end

  def parent_goal_name
    parent_goal.nil? ? "" : parent_goal.name
  end
end
